-- ftplugin/heex.lua
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.commentstring = "<!-- %s -->"

local cmd = 'elixir-ls'
if vim.fn.executable(cmd) ~= 1 then
  if vim.fn.executable("language_server.sh") == 1 then
    cmd = "language_server.sh"
  else
    return
  end
end

local root_files = { 'mix.exs', '.git' }

-- Evita iniciar múltiplos clientes no mesmo projeto
local root_dir = require('user.lsp').find_root(root_files)
for _, client in pairs(vim.lsp.get_active_clients({ name = "elixirls" })) do
  if client.config.root_dir == root_dir then
    return
  end
end

vim.lsp.start({
  name = 'elixirls',
  cmd = { cmd },
  root_dir = root_dir,
  capabilities = require('user.lsp').make_client_capabilities(),
  on_attach = require('user.lsp').on_attach,
})
