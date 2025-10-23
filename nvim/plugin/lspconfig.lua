local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local caps = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then caps = cmp_lsp.default_capabilities(caps) end

local on_attach = function(_, bufnr)
  local map = function(m, lhs, rhs) vim.keymap.set(m, lhs, rhs, { buffer = bufnr, silent = true }) end
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "K",  vim.lsp.buf.hover)
  map("n", "<leader>rn", vim.lsp.buf.rename)
  map("n", "<leader>ca", vim.lsp.buf.code_action)
end

-- Ex.: Lua LS
lspconfig.lua_ls.setup({
  capabilities = caps,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})
