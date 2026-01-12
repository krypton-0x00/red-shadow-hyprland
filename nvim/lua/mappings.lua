require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

-- Remove default diagnostic keybinds
pcall(del, "n", "<leader>e")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float(nil, {
    focus = false,
    scope = "line",
    border = "rounded",
    source = "always",
  })
end, { desc = "Line diagnostics popup" })


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
