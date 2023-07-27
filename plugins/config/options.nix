{ config, lib, pkgs, ... }:

let
  inherit (lib) boolStr mkOption types writeIf;

  nvim = config.nvim;
in {
  options.nvim = {
    autoWrite = mkOption {
      description = "Enable auto write";
      type = types.bool;
      default = true;
    };

    background = mkOption {
      description = "Sets background color";
      type = types.str;
      default = "light";
    };

    clipboard = mkOption {
      description = "Sync with system clipboard";
      type = types.str;
      default = "unnamedplus";
    };

    foldMethod = mkOption {
      description = "The fold text blocks method";
      type = types.str;
      default = "syntax";
    };

    lineNumberRelative = mkOption {
      description = "Relative line numbers";
      type = types.bool;
      default = true;
    };

    mapLeader = mkOption {
      description = "Map key for leader key";
      type = types.str;
      default = " ";
    };

    mapLocalLeader = mkOption {
      description = "Map key for local leader key";
      type = types.str;
      default = "\\\\";
    };

    mapTimeout = mkOption {
      description =
        "Timeout in microseconds for Neovim to wait for a mapped action to complete";
      type = types.int;
      default = 300;
    };
  };

  config.nvim = {
    rawConfig = ''
      vim.g.mapleader = "${toString nvim.mapLeader}"
      vim.g.maplocalleader = "${toString nvim.mapLocalLeader}"

      local opt = vim.opt

      opt.autowrite = ${boolStr nvim.autoWrite}
      opt.clipboard = "${toString nvim.clipboard}"

      opt.completeopt = "menu,menuone,noselect"
      opt.conceallevel = 3 -- Hide * markup for bold and italic
      opt.confirm = true -- Confirm to save changes before exiting modified buffer
      opt.cursorline = true -- Enable highlighting of the current line
      opt.expandtab = true -- Use spaces instead of tabs
      opt.formatoptions = "jcroqlnt" -- tcqj
      opt.grepformat = "%f:%l:%c:%m"
      opt.grepprg = "rg --vimgrep"
      opt.ignorecase = true -- Ignore case
      opt.inccommand = "nosplit" -- preview incremental substitute
      opt.laststatus = 0
      opt.list = true -- Show some invisible characters (tabs...
      opt.mouse = "a" -- Enable mouse mode
      opt.number = true -- Print line number
      opt.pumblend = 10 -- Popup blend
      opt.pumheight = 10 -- Maximum number of entries in a popup
      opt.relativenumber = ${
        boolStr nvim.lineNumberRelative
      } -- Relative line numbers
      opt.scrolloff = 4 -- Lines of context
      opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
      opt.shiftround = true -- Round indent
      opt.shiftwidth = 2 -- Size of an indent
      opt.shortmess:append({ W = true, I = true, c = true })
      opt.showmode = false -- Dont show mode since we have a statusline
      opt.sidescrolloff = 8 -- Columns of context
      opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
      opt.smartcase = true -- Don't ignore case with capitals
      opt.smartindent = true -- Insert indents automatically
      opt.spelllang = { "en" }
      opt.splitbelow = true -- Put new windows below current
      opt.splitright = true -- Put new windows right of current
      opt.tabstop = 2 -- Number of spaces tabs count for
      opt.termguicolors = true -- True color support
      opt.timeoutlen = 300
      opt.undofile = true
      opt.undolevels = 10000
      opt.updatetime = 200 -- Save swap file and trigger CursorHold
      opt.wildmode = "longest:full,full" -- Command-line completion mode
      opt.winminwidth = 5 -- Minimum window width
      opt.wrap = false -- Disable line wrap

      if vim.fn.has("nvim-0.9.0") == 1 then
        opt.splitkeep = "screen"
        opt.shortmess:append({ C = true })
      end

      -- Fix markdown indentation settings
      vim.g.markdown_recommended_style = 0
    '';
  };
}
