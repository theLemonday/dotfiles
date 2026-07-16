{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
    vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers
  ];

  xdg.configFile."dprint/dprint.jsonc".text = builtins.toJSON {
    json = {
      indentWidth = 2;
    };
    dockerfile = { };
    plugins = pkgs.dprint-plugins.getPluginList (
      plugins: with plugins; [
        dprint-plugin-json
        dprint-plugin-dockerfile
        g-plane-pretty_yaml
        dprint-plugin-markdown
        dprint-plugin-toml
        g-plane-markup_fmt
      ]
    );
  };
}
