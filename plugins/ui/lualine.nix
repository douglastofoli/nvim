{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types withPlugins writeIf;
  plugin = config.nvim.ui.statusline;
in {
  options.nvim.ui.statusline = {
    enable = mkEnableOption "Enable statusline";
    global = mkOption {
      description = "Enable statusline in global mode";
      type = types.bool;
      default = true;
    };
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins; [ lualine ];

    rawConfig = ''
      require('lualine').setup({
        options = {
          theme = "auto",
          globalstatus = ${
            if plugin.global then toString true else toString false
          },
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_z = {
            function()
              return os.date("%R")
            end,
          },
        },
      })
    '';
  };
}
