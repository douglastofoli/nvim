{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types withPlugins writeIf;
  plugin = config.nvim.coding.completion;
  isLuaSnippet = plugin.snippets.enable && plugin.snippets.source == "luasnip";
in {
  options.nvim.coding.completion = {
    enable = mkEnableOption "Enables auto completion";
    buffer.enable = mkEnableOption "Enables buffer auto completion";
    cmdline.enable = mkEnableOption "Enables cmdline auto completion";
    path.enable = mkEnableOption "Enables paths auto completion";
    lsp = {
      enable = mkEnableOption "Enables LSP auto completion";
      lspkind.enable = mkEnableOption "Enables VScode like pictograms";
    };
    snippets = {
      enable = mkEnableOption "Enables snippets completion";
      source = mkOption {
        description = "Define the snippet plugin source";
        type = types.enum [ "luasnip" ];
        default = "luasnip";
      };
    };
  };

  config.nvim = mkIf plugin.enable {
    startPlugins = with pkgs.neovimPlugins;
      ((withPlugins plugin.buffer.enable [ cmp-buffer ])
        ++ (withPlugins plugin.cmdline.enable [ cmp-cmdline ])
        ++ (withPlugins plugin.lsp.enable [ cmp-nvim-lsp ])
        ++ (withPlugins plugin.path.enable [ cmp-path ])
        ++ (withPlugins (plugin.lsp.enable && plugin.lsp.lspkind.enable)
          [ lspkind ]) ++ (withPlugins isLuaSnippet [ luasnip ])
        ++ [ nvim-cmp ]);

    rawConfig = ''
      ${writeIf isLuaSnippet ''
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
      ''}

      local cmp = require("cmp")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, column = unpack(vim.api.nvim_win_get_cursor(0))
        return column ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(column, column):match("%s") == nil
      end

      cmp.setup({
        ${
          writeIf plugin.lsp.enable ''
            formatting = {
              format = require("lspkind").cmp_format({
                mode = "symbol",
                maxwidth = 35,
                ellipsis_char = "...",
              }),
            },
          ''
        }
        ${
          writeIf (isLuaSnippet && plugin.lsp.enable) ''
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
          ''
        }
      })
    '';
  };
}
