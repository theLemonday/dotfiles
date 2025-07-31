{ pkgs, ... }: {
  home.packages = with pkgs;[
    harper
  ];

  home.sessionVariables = {
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    # XMODIFIERS = "@im=fcitx";
    # INPUT_METHOD = "fcitx5";
    # SDL_IM_MODULE = "fcitx";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-configtool
        fcitx5-chinese-addons
        fcitx5-unikey
        fcitx5-bamboo
        fcitx5-nord
      ];
      settings = {
        globalOptions = {
          Hotkey = {
            TriggerInputMethod = true;
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Super+space";
            "1" = "Control+space";
          };
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "unikey";
          "Groups/0/Items/2".Name = "pinyin";
          "Groups/0/Items/3".Name = "keyboard-de";
        };
        addons.pinyin.globalSection = {
          PageSize = 7;
          SpellEnabled = "True";
          SymbolsEnabled = "True";
          ChaiziEnabled = "True";
          ExtBEnabled = "True";
          CloudPinyinEnabled = "True";
          CloudPinyinIndex = 2;
          CloudPinyinAnimation = "True";
          PinyinInPreedit = "True";
          Prediction = "False";
          SwitchInputMethodBehavior = "Commit current preedit";
          SecondCandidate = "";
          ThirdCandidate = "";
          UseKeypadAsSelection = "True";
          BackSpaceToUnselect = "True";
          NumberOfSentence = 2;
          LongWordLengthLimit = 4;
          QuickPhraseKey = "semicolon";
          VAsQuickphrase = "True";
          FirstRun = "False";
        };
        addons.cloudpinyin.globalSection = {
          MinimumPinyinLength = 2;
          Backend = "Baidu";
          "Toggle Key" = "";
        };
      };
    };
  };
}
