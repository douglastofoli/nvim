-- plugin/treesitter.lua
local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ok then return end

-- Diretório de parsers gravável (fora da Nix store)
local install = require("nvim-treesitter.install")
local parser_dir = vim.fn.stdpath("data") .. "/parsers"
vim.fn.mkdir(parser_dir, "p")                 -- garante que existe
vim.opt.runtimepath:append(parser_dir)        -- rtp precisa conhecer o dir
install.prefer_git = false                    -- usa release tarball quando possível
-- install.compilers = { "clang", "gcc", "cc" } -- opcional: especifique compiladores

ts_configs.setup({
  -- Liste suas linguagens, mas sem auto-instalação automática
  ensure_installed = {
    "elixir", "heex", "eex",
    "lua", "vim", "vimdoc", "query",
    "bash", "json", "yaml", "toml",
    "markdown", "regex", "gitignore",
  },
  parser_install_dir = parser_dir,
  auto_install = false,        -- evita tentar instalar ao abrir arquivo
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
