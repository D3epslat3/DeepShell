local configs = require("modulos.configs")

local M = {}

-- Converte as configurações de cores para o formato LS_COLORS
function M.generate_ls_colors()
    local colors = configs.CONFIG.ls_colors
    if not colors.enabled then
        return ""
    end

    local ls_colors = {
        -- Tipos básicos
        "di=" .. (colors.custom_colors.dir or "01;34"),      -- directory
        "ex=" .. (colors.custom_colors.exe or "01;32"),      -- executable
        "ln=" .. (colors.custom_colors.link or "01;36"),     -- symbolic link
        "pi=" .. (colors.custom_colors.special or "01;33"),  -- pipe
        "so=" .. (colors.custom_colors.special or "01;33"),  -- socket
        "bd=" .. (colors.custom_colors.special or "01;33"),  -- block device
        "cd=" .. (colors.custom_colors.special or "01;33"),  -- character device
    }

    -- Adiciona cores para extensões específicas
    for ext, color in pairs(colors.custom_colors.extensions) do
        table.insert(ls_colors, "*" .. ext .. "=" .. color)
    end

    return table.concat(ls_colors, ":")
end

-- Configura as cores do ls
function M.setup()
    if configs.CONFIG.ls_colors.enabled then
        os.setenv("LS_COLORS", M.generate_ls_colors())
        os.setenv("CLICOLOR", "1")
    end
end

return M