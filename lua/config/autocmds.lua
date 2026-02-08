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
        orange = "#d19a66", -- numbers/booleans
        red    = "#E06C75", -- variables/operators
        green  = "#98c379", -- strings
        yellow = "#E5C07B", -- classes/types
        blue   = "#61AFEF", -- functions/methods
        purple = "#C678DD", -- keywords/builtin vars
        cyan   = "#56B6C2", -- builtins/parameters
        gray   = "#5c6370", -- comments
    }

    -- Standard Treesitter Groups
    local highlights = {
        -- Variables & Identifiers
        ["@variable"]          = { fg = colors.red },
        ["@variable.builtin"]  = { fg = colors.purple, bold = true }, -- self, this
        ["@variable.parameter"] = { fg = colors.cyan, italic = true },
        ["@variable.member"]    = { fg = colors.red }, -- object.member
        ["@property"]          = { fg = colors.red },

        -- Functions & Methods
        ["@function"]          = { fg = colors.blue, bold = true },
        ["@function.call"]     = { fg = colors.blue },
        ["@function.builtin"]  = { fg = colors.cyan }, -- print()
        ["@method"]            = { fg = colors.blue },
        ["@method.call"]       = { fg = colors.blue },

        -- Keywords & Types
        ["@keyword"]           = { fg = colors.purple, italic = true },
        ["@keyword.function"]  = { fg = colors.purple, bold = true }, -- 'def', 'function'
        ["@type"]              = { fg = colors.yellow },
        ["@type.builtin"]      = { fg = colors.yellow },
        ["@module"]            = { fg = colors.yellow }, -- pygame, os, etc.
        ["@namespace"]         = { fg = colors.yellow },

        -- Literals
        ["@number"]            = { fg = colors.orange },
        ["@boolean"]           = { fg = colors.orange },
        ["@string"]            = { fg = colors.green },
        ["@constant"]          = { fg = colors.orange },

        -- Comments
        ["Comment"]            = { fg = colors.gray, italic = true },
        ["@comment"]           = { fg = colors.gray },
        ["@string.documentation"] = { fg = colors.gray },
    }

    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

-- Apply on Colorscheme change (after theme loads)
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = setup_colors,
})

-- Apply on FileType to ensure they stick
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "cpp", "c", "java", "lua" },
    callback = setup_colors,
})

-- Initial run
setup_colors()
