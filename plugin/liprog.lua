local g = vim.g
local fn = vim.fn

if 1 ~= fn.has "nvim-0.9.0" then
    vim.notify "liprog requires Neovim 0.9.0 or newer"
    return
end

if g.loaded_liprog then
    return
end
g.loaded_liprog = true

-- run code block
vim.cmd [[command! -nargs=0 LiprogRun :lua require('liprog').run_if_lua()]]

-- set keymap
vim.api.nvim_set_keymap(
    "n",
    "<leader>lp",
    "<cmd>lua require('liprog').run_if_lua()<cr>",
    { noremap = true, silent = true })
