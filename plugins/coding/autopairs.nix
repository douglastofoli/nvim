{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  plugin = config.nvim.coding.autopairs;
in {
  options.nvim.coding.autopairs.enable =
    mkEnableOption "Enables the auto pairs";

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ nvim-autopairs ];

    rawConfig = ''
      require('nvim-autopairs').setup()
    '';
  };
}
