local M = {}

function M.log(message, level)
    local log_file = os.getenv("HOME") .. "/.config/deepshell/deepshell.log"
    local f = io.open(log_file, "a")
    if f then
        f:write(os.date("%Y-%m-%d %H:%M:%S") .. " [" .. (level or "INFO") .. "] " .. message .. "\n")
        f:close()
    end
end

return M