{
  programs.plasma = {
    enable = true;

    hotkeys = {
      commands = {
        "input-method-to-US" = {
          command = "fcitx5-remote -s fcitx-keyboard-us";
          key = "Ctrl+!";
        };
        "input-method-to-Unikey" = {
          command = "fcitx5-remote -s unikey";
          key = "Ctrl+@";
        };
        "input-method-to-Pinyin" = {
          command = "fcitx5-remote -s pinyin";
          key = "Ctrl+#";
        };
        "input-method-to-German" = {
          command = "fcitx5-remote -s keyboard-de";
          key = "Ctrl+$";
        };
        "input-method-to-Spanish" = {
          command = "fcitx5-remote -s keyboard-es";
          key = "Ctrl+%";
        };
      };
    };
  };
}
