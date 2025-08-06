{ pkgs, ... }:
{
  programs.plasma = {
    enable = true;

    panels = [
      {
        location = "top";
        height = 26;
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
                alphaSort = true;
              };
            };
          }
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }

    ];

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
