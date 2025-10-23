local ok, elixir = pcall(require, "elixir")
if not ok then return end

elixir.setup({
  nextls = { enable = false }, -- habilite se usar Next LS
  credo = { enable = true },
  elixirls = {
    enable = true,
    -- cmd = { "/caminho/para/elixir-ls/language_server.sh" }, -- se precisar
    settings = {
      elixirLS = {
        dialyzerEnabled = false,
        fetchDeps = false,
      },
    },
  },
})
