local ok, ls = pcall(require, "luasnip")
if not ok then return end

pcall(require, "luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})
