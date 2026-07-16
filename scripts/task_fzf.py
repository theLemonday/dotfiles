#!/usr/bin/env python3
"""
Fuzzy-pick a Task task and drop `task -g <name> ` onto the next zsh prompt
(via `print -z`), with a live preview showing only the cmds + vars that are
actually referenced by the highlighted task.

Normal usage (from the shell wrapper):
    task_fzf.py [taskfile-path]
    -> prints "task -g <name> " to stdout if something was selected,
       prints nothing (exit 0) if the user aborted fzf.

Preview usage (invoked by fzf itself, not meant to be run by hand):
    task_fzf.py --preview <task-name> [taskfile-path]
    -> prints the cmds + relevant vars for that one task.
"""

import json
import os
import re
import shlex
import subprocess
import sys

import yaml

VAR_PATTERN = re.compile(r"\{\{\s*\.([A-Za-z_][A-Za-z0-9_]*)")
DEFAULT_TASKFILE = os.path.expanduser(os.path.join("~", "Taskfile.yml"))


def collect_cmd_text(cmds) -> str:
    """Flatten a task's `cmds:` list into a single string of shell text."""
    parts = []
    if not cmds:
        return ""
    for entry in cmds:
        if isinstance(entry, str):
            parts.append(entry)
        elif isinstance(entry, dict) and isinstance(entry.get("cmd"), str):
            parts.append(entry["cmd"])
    return "\n".join(parts)


def format_var_value(value) -> str:
    if isinstance(value, dict) and "sh" in value:
        return f"(dynamic var, sh: {value['sh']!r})"
    if value is None:
        return "(not defined — likely a CLI override or dynamic var)"
    return str(value)


def load_taskfile(taskfile_path: str) -> dict:
    with open(taskfile_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def run_preview(task_name: str, taskfile_path: str) -> int:
    try:
        data = load_taskfile(taskfile_path)
    except FileNotFoundError:
        print(f"Taskfile not found: {taskfile_path}")
        return 0

    tasks = data.get("tasks", {}) or {}
    task = tasks.get(task_name)

    if not task:
        print(f"Task '{task_name}' not found in {taskfile_path}")
        return 0

    cmd_text = collect_cmd_text(task.get("cmds"))

    print("── cmds ──")
    print(cmd_text if cmd_text else "(no literal cmds — likely just calls other tasks)")

    used_vars = sorted(set(VAR_PATTERN.findall(cmd_text)))

    if used_vars:
        task_vars = task.get("vars", {}) or {}
        global_vars = data.get("vars", {}) or {}

        print("\n── vars used ──")
        for name in used_vars:
            value = task_vars[name] if name in task_vars else global_vars.get(name)
            print(f"{name}: {format_var_value(value)}")

    return 0


def list_tasks(taskfile_path: str) -> list[dict]:
    result = subprocess.run(
        ["task", "-g", "-t", taskfile_path, "--list-all", "--json"],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(result.stdout).get("tasks", [])


def run_picker(taskfile_path: str) -> int:
    try:
        tasks = list_tasks(taskfile_path)
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"Failed to list tasks: {e}", file=sys.stderr)
        return 1

    if not tasks:
        print("No tasks found.", file=sys.stderr)
        return 1

    lines = [f"{i}\t{t['name']}\t{t.get('desc', '')}" for i, t in enumerate(tasks, start=1)]

    script_path = os.path.abspath(__file__)
    preview_cmd = " ".join(
        shlex.quote(part)
        for part in (sys.executable, script_path, "--preview", "{2}", taskfile_path)
    )

    fzf = subprocess.run(
        [
            "fzf",
            "--delimiter",
            "\t",
            "--with-nth",
            "1,2,3",
            "--preview",
            preview_cmd,
            "--preview-window",
            "right:60%:wrap",
            "--header",
            "enter: load into prompt (add args, then hit enter to run)",
        ],
        input="\n".join(lines),
        capture_output=True,
        text=True,
    )

    if fzf.returncode != 0 or not fzf.stdout.strip():
        return 0  # user aborted (Esc/Ctrl-C) — print nothing

    task_name = fzf.stdout.strip().split("\t")[1]
    print(f"task -g {task_name} ", end="")
    return 0


def main() -> int:
    args = sys.argv[1:]

    if args and args[0] == "--preview":
        task_name = args[1]
        taskfile_path = args[2] if len(args) > 2 else DEFAULT_TASKFILE
        return run_preview(task_name, taskfile_path)

    taskfile_path = args[0] if args else DEFAULT_TASKFILE
    return run_picker(taskfile_path)


if __name__ == "__main__":
    raise SystemExit(main())
