local ok, gitsigns = pcall(require, "gitsigns")
if not ok then return end

gitsigns.setup({
  current_line_blame = true,
  on_attach = function(bufnr)
    local map = function(m, lhs, rhs) vim.keymap.set(m, lhs, rhs, { buffer = bufnr }) end
    map("n", "]h", gitsigns.next_hunk)
    map("n", "[h", gitsigns.prev_hunk)
    map("n", "<leader>hs", gitsigns.stage_hunk)
    map("n", "<leader>hr", gitsigns.reset_hunk)
    map("n", "<leader>hp", gitsigns.preview_hunk)
  end,
})
