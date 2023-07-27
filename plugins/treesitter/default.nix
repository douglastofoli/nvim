{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  plugin = config.nvim.treesitter;
  orgmode = config.nvim.util.orgmode;
in {
  options.nvim.treesitter = {
    enable = mkEnableOption "Enable tree-sitter";
    autotag.enable = mkEnableOption "Enables auto tagging";
    context.enable = mkEnableOption "Enables block context";
    rainbow.enable = mkEnableOption "Enables rainbow colored pairs";
    ensure-installed = mkOption {
      description = "Language packages";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins;
      ((withPlugins plugin.autotag.enable [ nvim-ts-autotag ])
        ++ (withPlugins plugin.context.enable [ nvim-ts-context ])
        ++ (withPlugins plugin.rainbow.enable [ nvim-ts-rainbow ]) ++ [
          (pkgs.vimPlugins.nvim-treesitter.withPlugins
            (p: map (l: p.${l}) plugin.ensure-installed))
        ]);

    globals = {
      "foldmethod" = "expr";
      "foldexpr" = "nvim_treesitter#foldexpr()";
      "nofoldenable" = 1;
    };

    rawConfig = ''
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          use_languagetree = true,

          ${
            writeIf orgmode.enable ''
              additional_vim_regex_highlighting = {"org"},
            ''
          }
        },
        ${
          writeIf plugin.autotag.enable ''
            autotag = {
              enable = true,
            },
          ''
        }
        ${
          writeIf plugin.context.enable ''
            require("treesitter-context").setup({
              enable = true,
              throttle = true,
              max_lines = 0,
            }),
          ''
        }
        ${
          writeIf plugin.rainbow.enable ''
            rainbow = {
              enable = true,
              query = 'rainbow-parens',
              strategy = require("ts-rainbow").strategy.global,
            },
          ''
        }
      })
    '';
  };
}
