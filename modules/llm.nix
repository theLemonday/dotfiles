{
  # in your home.nix
  services.ollama = {
    enable = true;
    # To enable acceleration, you might need to specify your hardware.
    # For NVIDIA:
    acceleration = "cuda";
    # For AMD (more experimental):
    # acceleration = "rocm";
  };
}
