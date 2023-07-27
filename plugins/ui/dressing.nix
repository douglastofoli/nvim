{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  plugin = config.nvim.ui.dressing;
in {
  options.nvim.ui.dressing = {
    enable =
      mkEnableOption "Enable plugin to improve the default vim.ui interfaces";
    input.enable = mkEnableOption "Enable input features";
    select.enable = mkEnableOption "Enable select features";
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ dressing ];

    rawConfig = ''
      require("dressing").setup({
        input = {
          enable = ${toString plugin.input.enable},
        },
        select = {
          enable = ${toString plugin.select.enable},
        },
      })
    '';
  };
}
