#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["genanki", "markdown"]
# ///
"""Markdown -> Anki .apkg.

Format:
    # Deck title #k8s          (optional; trailing #tags are inherited by every card)
    ## Front of the card #dns  (trailing #tags are added to this card)
    Back of the card (Markdown, fenced code blocks supported)

Tags are shown on the front of the card. Re-importing is safe: the note GUID
comes from deck + front text, so editing the back updates the card.
"""

import argparse
import re
import sys
import zlib
from pathlib import Path

import genanki
import markdown

TRAIL_TAGS = re.compile(r"(?:\s+#[\w:-]+)+\s*$")  # tags only count at the END of the line
# Light: gruvbox-material-light-medium. Dark: gruvbox-dark-hard.
# Anki adds .nightMode (.night_mode on AnkiDroid) when its theme is dark; with
# Preferences > Appearance > Theme = "Follow system" that tracks the OS theme.
CSS = """
.card {
  --bg: #fbf1c7; --bg-soft: #f4e8be; --line: #d5c4a1;
  --fg: #654735; --muted: #928374; --accent: #b47109; --link: #45707a;
  background: var(--bg); color: var(--fg);
  font-family: sans-serif; text-align: left; line-height: 1.45;
}
.card.nightMode, .nightMode .card, .card.night_mode, .night_mode .card {
  --bg: #1d2021; --bg-soft: #282828; --line: #504945;
  --fg: #ebdbb2; --muted: #928374; --accent: #fabd2f; --link: #83a598;
}
.tags { margin-bottom: .8em; font-size: .8em; color: var(--accent); }
a { color: var(--link); }
hr#answer { border: 0; border-top: 1px solid var(--line); margin: 1em 0; }
pre { background: var(--bg-soft); border: 1px solid var(--line);
      padding: .6em; overflow-x: auto; }
code { background: var(--bg-soft); padding: 0 .25em; }
pre code { background: none; padding: 0; }
"""

MODEL = genanki.Model(
    1607392319,  # fixed ID: never change it, or Anki treats it as a new note type
    "Markdown Basic",
    fields=[{"name": "Front"}, {"name": "Back"}],
    templates=[
        {
            "name": "Card 1",
            "qfmt": "<div class=tags>{{Tags}}</div>{{Front}}",
            "afmt": "{{FrontSide}}<hr id=answer>{{Back}}",
        }
    ],
    css=CSS,
)


def split_tags(line: str) -> tuple[str, list[str]]:
    """'Some text #a #b' -> ('Some text', ['a', 'b'])"""
    m = TRAIL_TAGS.search(line)
    if not m:
        return line.strip(), []
    return line[: m.start()].strip(), [t[1:] for t in m.group().split()]


def parse(text: str, fallback: str):
    """Return (deck_title, [(front, back_html, tags)])."""
    title, deck_tags, cards, cur, in_fence = fallback, [], [], None, False
    seen_title = False
    for line in text.splitlines():
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
        elif not in_fence:
            if line.startswith("## "):
                front, tags = split_tags(line[3:])
                cur = [front, tags, []]
                cards.append(cur)
                continue
            if line.startswith("# ") and not seen_title and cur is None:
                title, deck_tags = split_tags(line[2:])
                seen_title = True
                continue
        if cur is not None:
            cur[2].append(line)

    out = []
    for front, tags, body_lines in cards:
        body = "\n".join(body_lines).strip()
        if not body:
            print(f"skip (empty back): {front}", file=sys.stderr)
            continue
        html = markdown.markdown(body, extensions=["fenced_code"])
        out.append((front, html, list(dict.fromkeys(deck_tags + tags))))
    return title, out


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("inputs", nargs="+", type=Path, help=".md files or directories")
    ap.add_argument("-o", "--output", type=Path, default=Path("cards.apkg"))
    args = ap.parse_args()

    files = []
    for p in args.inputs:
        files += sorted(p.rglob("*.md")) if p.is_dir() else [p]

    decks = []
    for f in files:
        title, cards = parse(f.read_text(encoding="utf-8"), f.stem)
        deck = genanki.Deck(zlib.crc32(title.encode()) & 0x7FFFFFFF, title)
        for front, back, tags in cards:
            deck.add_note(
                genanki.Note(
                    model=MODEL,
                    fields=[markdown.markdown(front)[3:-4], back],  # strip <p></p>
                    tags=tags,
                    guid=genanki.guid_for(title, front),
                )
            )
        decks.append(deck)
        print(f"{f}: {len(cards)} cards -> deck '{title}'")

    genanki.Package(decks).write_to_file(args.output)
    print(f"wrote {args.output}")


if __name__ == "__main__":
    main()
