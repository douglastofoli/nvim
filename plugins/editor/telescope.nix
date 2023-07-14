{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  plugin = config.nvim.editor.telescope;
in {
  options.nvim.editor.telescope = {
    enable = mkEnableOption "Enable telescope";
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ telescope ];

    rawConfig = ''
      require("telescope").setup({
        defaults = {
          pickers = {
            find_command = { 
              "${pkgs.fd}/bin/fd" 
            },
          },
        },
      })
    '';
  };
}
