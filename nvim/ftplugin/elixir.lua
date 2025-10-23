vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.commentstring = "# %s"

local cmd = "expert" -- binário do expert-ls
if vim.fn.executable(cmd) ~= 1 then
  vim.notify("[Elixir] expert-ls não encontrado no PATH", vim.log.levels.WARN)
  return
end

-- registra o servidor "expert"
vim.lsp.config("expert", {
  cmd = { cmd },
  filetypes = { "elixir", "eelixir", "heex" },
  root_markers = { "mix.exs", ".git" },
  capabilities = require("user.lsp").make_client_capabilities(),
  on_attach = require("user.lsp").on_attach,
  settings = {
    expert = {
      suggestSpecs = true,
      dialyzer = false,
      signatureAfterComplete = true,
      codeLens = true,
    },
  },
})

-- inicia o LSP "expert" para o buffer atual
vim.lsp.enable("expert")
