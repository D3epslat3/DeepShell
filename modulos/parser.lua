local utils = require("modulos.utils")

local M = {}

function M.parse_command(input)
    if not input or input:match("^%s*$") then
        return nil
    end

    local parts = utils.split_string(input)
    local command = parts[1]
    table.remove(parts, 1)
    
    return {
        command = command,
        args = parts
    }
end

return M