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
