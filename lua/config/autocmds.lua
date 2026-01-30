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
    elseif vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
        -- Directory open logic
        vim.cmd("Neotree show filesystem left")
        pcall(vim.cmd, "AerialOpen!")
        -- Focus the file list or empty buffer
        vim.cmd("wincmd p")
    end
  end,
})
