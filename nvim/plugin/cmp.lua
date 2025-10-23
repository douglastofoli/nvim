local ok, cmp = pcall(require, "cmp")
if not ok then return end

local ok_luasnip, luasnip = pcall(require, "luasnip")
if ok_luasnip then
  pcall(require, "luasnip.loaders.from_vscode").lazy_load()
end

cmp.setup({
  snippet = {
    expand = function(args)
      if ok_luasnip then luasnip.lsp_expand(args.body) end
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif ok_luasnip and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ok_luasnip and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "path" },
    { name = "buffer" },
  }),
  experimental = { ghost_text = true },
})
