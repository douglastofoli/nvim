-- ftplugin/json.lua
vim.bo.commentstring = "// %s"

local cmd = "vscode-json-language-server"
if vim.fn.executable(cmd) ~= 1 then
  return
end

local root = require('user.lsp').find_root({ ".git", "package.json", "tsconfig.json" })

vim.lsp.start({
  name = "jsonls",
  cmd = { cmd, "--stdio" },
  root_dir = root,
  capabilities = require('user.lsp').make_client_capabilities(),
  on_attach = require('user.lsp').on_attach,
  settings = {
    json = {
      validate = { enable = true },
      schemas = require("schemastore") and require("schemastore").json.schemas() or nil,
    },
  },
})
