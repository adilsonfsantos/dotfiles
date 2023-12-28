local key = vim.keymap.set

key("n", "<Leader>f", vim.cmd.Neotree, { desc = 'Open Neo-tree' })
key("n", "<Leader>u", vim.cmd.UndotreeToggle, { desc = "Open Undotree"})
key("n", "<Leader>p", [[:%!prettierd %<CR>]], { noremap = true, desc = "Format with Prettierd" })
key("n", "<F5>", ":'<,'>sort", {desc = "Sort lines"})
