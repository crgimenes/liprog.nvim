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

-- get line count in buffer
M.get_line_count = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    return line_count
end

-- find code start
M.find_code_start = function(line_number)
    local line = M.get_line(line_number)
    local language = string.match(line, "```(.*)")
    if language then
        return { ["line"] = line_number, ["language"] = language }
    end
    if line_number > 1 then
        return M.find_code_start(line_number - 1)
    end
    return nil
end

-- find code end
M.find_code_end = function(line_number)
    local line = M.get_line(line_number)
    local language = string.match(line, "```(.*)")
    if language then
        return { ["line"] = line_number, ["language"] = language }
    end
    if line_number < M.get_line_count() then
        return M.find_code_end(line_number + 1)
    end
    return nil
end


return M
