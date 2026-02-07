-- Autocommands
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local should_show_dashboard = vim.fn.argc() == 0
    
    if should_show_dashboard then
        -- 1. Open Alpha explicitly to ensure it's loaded in the main window
        vim.cmd("Alpha")
        
        -- 2. Open sidebars
        -- Neotree on the left
        vim.cmd("Neotree show filesystem left")
        -- Aerial on the right
        pcall(vim.cmd, "AerialOpen!")

        -- 3. Force focus back to the center window (the Dashboard)
        -- We iterate through windows to find the one containing the dashboard
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.api.nvim_buf_get_option(buf, "filetype")
            if ft == "alpha" then
                vim.api.nvim_set_current_win(win)
                break
            end
        end
    elseif vim.fn.argc() > 0 then
        -- File or Directory open logic
        local is_dir = vim.fn.isdirectory(vim.fn.argv(0)) == 1
        
        -- Open sidebars
        vim.cmd("Neotree show filesystem left")
        pcall(vim.cmd, "AerialOpen!")
        
        -- If it's a file, we want to focus the file window (center), not the sidebars
        if not is_dir then
            -- Iterate to find the window that is NOT a sidebar
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.api.nvim_buf_get_option(buf, "filetype")
                if ft ~= "neo-tree" and ft ~= "aerial" then
                    vim.api.nvim_set_current_win(win)
                    break
                end
            end
        else
             -- If it's a directory, focus the file explorer
             vim.cmd("wincmd p")
        end
    end
  end,
})

-- CUSTOM HIGHLIGHTS
local function setup_colors()
    local colors = {
        gray = "#5c6370",
        red = "#e06c75",
        blue = "#61afef",
        cyan = "#56b6c2",
        green = "#98c379",
        yellow = "#e5c07b",
        orange = "#d19a66",
        purple = "#c678dd",
    }

    -- 1. Standard Vim Highlights (Fallback)
    vim.api.nvim_set_hl(0, "Comment", { fg = colors.gray, italic = true })
    vim.api.nvim_set_hl(0, "@comment", { fg = colors.gray, italic = true })
    vim.api.nvim_set_hl(0, "@string.documentation", { fg = colors.gray })

    -- 2. Treesitter Highlights
    -- Python 'self' / C++ 'this'
    vim.api.nvim_set_hl(0, "@variable.builtin", { fg = colors.red, bold = true })
    
    -- Modules (e.g., 'pygame')
    vim.api.nvim_set_hl(0, "@module", { fg = colors.blue })
    vim.api.nvim_set_hl(0, "@namespace", { fg = colors.blue })
    
    -- Properties / Member variables
    vim.api.nvim_set_hl(0, "@property", { fg = colors.cyan })
    vim.api.nvim_set_hl(0, "@variable.member", { fg = colors.cyan })
    
    -- Parameters
    vim.api.nvim_set_hl(0, "@variable.parameter", { fg = colors.orange })

    -- Functions/Methods
    vim.api.nvim_set_hl(0, "@function", { fg = colors.green })
    vim.api.nvim_set_hl(0, "@method", { fg = colors.green })
    vim.api.nvim_set_hl(0, "@function.call", { fg = colors.green })
    
    -- Types/Classes
    vim.api.nvim_set_hl(0, "@type", { fg = colors.yellow })
    vim.api.nvim_set_hl(0, "@constructor", { fg = colors.yellow })
end

-- Run on Colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = setup_colors,
})

-- Run on FileType to be extra sure
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "cpp", "c" },
    callback = function()
        setup_colors()
        if vim.bo.filetype == "python" then
            vim.cmd([[syn keyword pythonSelf self]])
            vim.api.nvim_set_hl(0, "pythonSelf", { fg = "#e06c75", bold = true })
        end
    end,
})

-- Initial run
setup_colors()
