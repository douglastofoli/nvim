{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  plugin = config.nvim.treesitter;
in {
  options.nvim.treesitter = {
    enable = mkEnableOption "Enable tree-sitter";
    ensure-installed = mkOption {
      description = "Language packages";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins;
      ([
        (pkgs.vimPlugins.nvim-treesitter.withPlugins
          (p: map (g: p.${g}) plugin.ensure-installed))
      ]);
  };
}
