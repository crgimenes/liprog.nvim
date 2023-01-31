local M = {}

local default_config = {}

M.setup = function(opts)
    vim.g.liprog_settings = opts or default_config
end

return M
