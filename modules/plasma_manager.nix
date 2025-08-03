{
  programs.plasma = {
    hotkeys = {
      commands = {
        "Change input method to US" = {
          command = "fcitx5-remote -s fcitx-keyboard-us";
          key = "Ctrl+!";
        };
        "Change input method to Unikey" = {
          command = "fcitx5-remote -s unikey";
          key = "Ctrl+@";
        };
        "Change input method to Pinyin" = {
          command = "fcitx5-remote -s pinyin";
          key = "Ctrl+#";
        };
        "Change input method to German keyboard" = {
          command = "fcitx5-remote -s keyboard-de";
          key = "Ctrl+$";
        };
        "Change input method to Spanish keyboard" = {
          command = "fcitx5-remote -s keyboard-es";
          key = "Ctrl+%";
        };
      };
    };
  };
}
