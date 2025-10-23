local ok, copilot = pcall(require, "copilot")
if not ok then return end

copilot.setup({
  suggestion = { enabled = false }, -- usar via nvim-cmp
  panel = { enabled = false },
})
