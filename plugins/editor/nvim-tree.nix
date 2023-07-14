{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  plugin = config.nvim.editor.nvim-tree;
in {
  options.nvim.editor.nvim-tree = {
    enable = mkEnableOption "Enable nvim-tree";
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ nvim-tree ];

    nnoremap = { "<leader>e" = ":NvimTreeToggle<CR>"; };

    rawConfig = ''
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
      })
    '';
  };
}
