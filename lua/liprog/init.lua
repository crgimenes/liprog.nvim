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
        return { ["line"] = line_number - 1, ["language"] = language }
    end
    if line_number < M.get_line_count() then
        return M.find_code_end(line_number + 1)
    end
    return nil
end

-- get code block and language where cursor is located
M.get_code_block = function()
    local line_number = M.get_current_line_number()
    local code_start = M.find_code_start(line_number)
    local code_end = M.find_code_end(line_number)
    if code_start and code_end then
        local code_block = vim.api.nvim_buf_get_lines(0, code_start.line, code_end.line, false)
        code_block = table.concat(code_block, "\n")
        return { ["code_block"] = code_block, ["language"] = code_start.language }
    end
    return nil
end

-- run lua code
M.run_lua = function(code_block)
    local f, err = load(code_block)
    if err then
        print("error loading: " .. err)
        return err
    end
    local ok, result = pcall(f)
    if ok then
        if result then
            print("result: " .. result)
            return result
        end
        print("result: nil")
        return nil
    end
    print("error: " .. result)
    return result
end

-- get code block and language where cursor is located and run it if it is lua code
M.run_if_lua = function()
    local code_block = M.get_code_block()
    if code_block then
        if code_block.language == "lua" then
            result = M.run_lua(code_block.code_block)
            M.replace_result(result)
        end
    end
end

-- find next ```result block and replace it with result
M.replace_result = function(result)
    if not result then
        return
    end
    print("replacing result")
    local line_number = M.get_current_line_number()
    local code_end = M.find_code_end(line_number)
    if code_end then
        print("code end: " .. code_end.line)
        local line = M.get_line(code_end.line + 1)
        for i = code_end.line + 1, M.get_line_count() do
            print("line: " .. line)
            local result_block = string.match(line, "```result(.*)")
            if result_block then
                print("replacing result")
                vim.api.nvim_buf_set_lines(0, i, i + 1, false, { tostring(result) })
                return
            end
            line = M.get_line(i + 1)
        end
    end
end

return M
