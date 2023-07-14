{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  plugin = config.nvim.ui.lualine;
in {
  options.nvim.ui.lualine.enable = mkEnableOption "Enable statusline";

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ lualine ];

    rawConfig = ''
      require('lualine').setup()
    '';
  };
}
