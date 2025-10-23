-- ftplugin/markdown.lua
vim.bo.textwidth = 100
vim.wo.colorcolumn = "100"
vim.bo.commentstring = "<!-- %s -->"

-- LSP opcional: marksman
local cmd = "marksman"
if vim.fn.executable(cmd) == 1 then
  local root = require('user.lsp').find_root({ ".git", ".marksman.toml", "README.md" })
  vim.lsp.start({
    name = "marksman",
    cmd = { cmd, "server" },
    root_dir = root,
    capabilities = require('user.lsp').make_client_capabilities(),
    on_attach = require('user.lsp').on_attach,
  })
end
