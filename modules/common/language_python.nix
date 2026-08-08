{ pkgs, ... }:
let
  myPython = pkgs.python312;

  # Convert the names to Nix package expressions
  pythonWithPkgs = myPython.withPackages (pythonPkgs: with pythonPkgs; [
    # This list contains tools for Python development.
    # You can also add other tools, like black.
    #
    # Note that even if you add Python packages here like PyTorch or Tensorflow,
    # they will be reinstalled when running `pip -r requirements.txt` because
    # virtualenv is used below in the shellHook.
    # pip
  ]);
in
{
  home.packages = [
    pythonWithPkgs
  ];

  programs.uv = {
    enable = true;
  };

  programs.ruff = {
    enable = true;
    settings = {
      line-length = 100;
    };
  };

  programs.ty = { enable = true; };
}
