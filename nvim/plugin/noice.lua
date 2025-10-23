local ok, noice = pcall(require, "noice")
if not ok then return end
-- Depende de 'nui.nvim'. 'nvim-notify' melhora UX.
noice.setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = { command_palette = true, long_message_to_split = true, inc_rename = false },
})
pcall(function() vim.notify = require("notify") end)
