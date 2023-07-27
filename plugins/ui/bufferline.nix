{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  plugin = config.nvim.ui.bufferline;
in {
  options.nvim.ui.bufferline.enable =
    mkEnableOption "Enable a snazzy bufferline for Neovim";

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ bufferline ];

    rawConfig = ''
      require("bufferline").setup()
    '';
  };
}
