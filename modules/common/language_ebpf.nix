{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- eBPF kernel side ---
    clang
    llvm

    clang-tools
    # use the host headers instead in a non-NixOs setup
    # sudo dnf install kernel-devel kernel-headers

    # --- codegen (cilium/ebpf uses bpf2go) ---
    # bpf2go is a Go tool, pulled via go.mod — but you need clang in PATH
    # nothing extra needed here if you use `go generate`

    # --- observability / debug ---
    perf
  ];
}
