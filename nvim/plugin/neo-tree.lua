local ok, neotree = pcall(require, "neo-tree")
if not ok then return end
-- Requer 'nui.nvim' e 'nvim-web-devicons'
neotree.setup({
  filesystem = {
    filtered_items = { hide_dotfiles = false, hide_gitignored = true },
    follow_current_file = { enabled = true },
  },
  window = { width = 32 },
})
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Explorer" })
