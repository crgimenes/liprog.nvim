local M = {}

local default_config = {}

M.setup = function(opts)
    vim.g.liprog_settings = opts or default_config
end

-- get current line number
M.get_current_line_number = function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    return line
end

-- get line by line number
M.get_line = function(line_number)
    local line = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]
    return line
end


return M
