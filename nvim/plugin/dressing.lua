local ok, dressing = pcall(require, "dressing")
if not ok then return end
-- Depende de 'nui.nvim'
dressing.setup({
  input = { border = "rounded" },
  select = { backend = { "telescope", "builtin" } },
})
