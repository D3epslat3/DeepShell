local M = {}

function M.check_dependencies()
    local missing = {}

    -- Verifica LuaJIT
    if not jit then
        table.insert(missing, "luajit")
    end

    -- Verifica LuaFileSystem
    local lfs_success = pcall(require, "lfs")
    if not lfs_success then
        table.insert(missing, "luafilesystem")
    end

    if #missing > 0 then
        print("Dependências faltando:")
        for _, dep in ipairs(missing) do
            print("  - " .. dep)
        end
        return false
    end

    return true
end

return M