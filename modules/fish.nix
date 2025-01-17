{ pkgs, ... }: {
  home.packages = [
    pkgs.fishPlugins.fzf-fish
    pkgs.fishPlugins.autopair
    pkgs.fishPlugins.tide
    pkgs.fishPlugins.z
  ];

  programs.fish = {
    enable = true;
    shellInit = ''
      tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Solid --prompt_connection_andor_frame_color=Darkest --prompt_spacing=Sparse --icons='Few icons' --transient=Yes

      just --completions fish > ~/.config/fish/completions/just.fish
    '';
  };
}
