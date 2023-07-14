{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  plugin = config.nvim.ui.which-key;
in {
  options.nvim.ui.which-key.enable = mkEnableOption "Enable which-key";

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ which-key ];

    rawConfig = ''
      require('which-key').setup({
        plugins = { spelling = true },
        defaults = {
          mode = { "n", "v" },
          ["g"] = { name = "+goto" },
        },
      })
    '';
  };
}
