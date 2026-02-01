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
    cython
    pyqt6
    ipython
    pip
    setuptools
    pipx
    # protobuf
    grpcio
    grpcio-tools
    # virtualenvwrapper
    wheel
    paramiko
    python-lsp-server
    python-lsp-ruff
    python-lsp-jsonrpc
    pylsp-rope
    # mypy
    debugpy
    click
    mutagen
  ]);
in
{
  home.packages = with pkgs;[
    pythonWithPkgs
    ty
  ];

  programs.uv = {
    enable = true;
  };

  programs.ruff = {
    enable = true;
    settings = {
      line-length = 100;
      # per-file-ignores = { "__init__.py" = [ "F401" ]; };
      # lint = {
      #   select = [ "E4" "E7" "E9" "F" ];
      #   ignore = [ ];
      # };
    };
  };
}
