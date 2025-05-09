{ pkgs, ... }:
let
  myPython = pkgs.python313;

  # Convert the names to Nix package expressions
  pythonWithPkgs = myPython.withPackages (pythonPkgs: with pythonPkgs; [
    # This list contains tools for Python development.
    # You can also add other tools, like black.
    #
    # Note that even if you add Python packages here like PyTorch or Tensorflow,
    # they will be reinstalled when running `pip -r requirements.txt` because
    # virtualenv is used below in the shellHook.
    ipython
    pip
    setuptools
    virtualenvwrapper
    wheel
    pylatexenc
    paramiko
    python-lsp-server
    python-lsp-ruff
    python-lsp-jsonrpc
    pylsp-rope
    # mypy
    debugpy
    ruff
    click
  ]);
in
{
  home.packages = [ pythonWithPkgs ];
}
