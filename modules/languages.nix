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
        # themes
        # fcitx5-nord
        # fcitx5-material-color
      ];
      settings = {
        globalOptions = {
          Hotkey = {
            TriggerInputMethod = true;
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Super+space";
            # "1" = "Control+space";
          };
          Behavior = {
            # Active By Default
            ActiveByDefault = false;
            # Reset state on Focus In
            resetStateWhenFocusIn = "No";
            # Share Input State
            ShareInputState = "All";
            # Show preedit in application
            PreeditEnabledByDefault = true;
            # Show Input Method Information when switch input method
            ShowInputMethodInformation = true;
            # Show Input Method Information when changing focus
            showInputMethodInformationWhenFocusIn = true;
            # Show compact input method information
            CompactInputMethodInformation = true;
            # Show first input method information
            ShowFirstInputMethodInformation = true;
            # Default page size
            DefaultPageSize = 5;
            # Override Xkb Option
            OverrideXkbOption = false;
            # Custom Xkb Option
            CustomXkbOption = "";
            # Force Enabled Addons
            EnabledAddons = "";
            # Force Disabled Addons
            DisabledAddons = "";
            # Preload input method to be used by default
            PreloadInputMethod = true;
            # Allow input method in the password field
            AllowInputMethodForPassword = false;
            # Show preedit text when typing password
            ShowPreeditForPassword = false;
            # Interval of saving user data in minutes
            AutoSavePeriod = 30;
          };
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "keyboard-de-neo_qwertz";
          };
          "Groups/0/Items/0".Name = "keyboard-de-neo_qwertz";
          "Groups/0/Items/1".Name = "unikey";
          "Groups/0/Items/2".Name = "pinyin";
          "Groups/0/Items/3".Name = "keyboard-es";
          "Groups/0/Items/4".Name = "keyboard-us";
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
          Backend = "GoogleCN";
          "Toggle Key" = "";
        };
      };
    };
  };
}
