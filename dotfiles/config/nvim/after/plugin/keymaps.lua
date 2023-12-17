vim.keymap.set("n", "<Leader>f", vim.cmd.Neotree, { desc = 'Open Neo-tree' })
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Open Undotree"})
vim.keymap.set('n', '<leader>p', [[:%!prettierd %<CR>]], { noremap = true, desc = "Format with Prettierd" })

