{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  plugin = config.nvim.ui;
in {
  options.nvim.ui = {
    enable = mkEnableOption "Enables general ui enhancement";
    legendary.enable = mkEnableOption "Enables legendary";
    which-key.enable = mkEnableOption "Enables keybinding preview";
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins;
      ((withPlugins (plugin.enable && plugin.legendary.enable) [ legendary ])
        ++ (withPlugins (plugin.enable && plugin.which-key.enable)
          [ which-key ]));

    rawConfig = ''
      require("which-key").setup()

      ${writeIf (plugin.enable && plugin.legendary.enable) ''
        require("legendary").setup({
          which_key = { auto_register = true }
        })
      ''}
    '';
  };
}
