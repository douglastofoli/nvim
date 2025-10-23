local ok, diffview = pcall(require, "diffview")
if not ok then return end

diffview.setup({})
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview Open" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview FileHistory" })
