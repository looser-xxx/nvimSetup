-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Compile and Run C++
-- Store the buffer ID of the terminal to close it on next run
local cpp_term_buf = nil

map("n", "<leader>rc", function()
  -- If a terminal buffer exists and is valid, delete it (closes the window)
  if cpp_term_buf and vim.api.nvim_buf_is_valid(cpp_term_buf) then
    vim.api.nvim_buf_delete(cpp_term_buf, { force = true })
  end

  local file = vim.fn.expand("%")
  local output = vim.fn.expand("%:r")
  
  -- Read content BEFORE opening the new split/buffer
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  
  vim.cmd("w")
  
  -- Open a horizontal split at the bottom with fixed height
  vim.cmd("botright 10new")
  
  -- Run the command in the new buffer
  local pkgs = {}
  local extra_flags = ""

  if content:match("SDL3") then
    table.insert(pkgs, "sdl3")
    extra_flags = "-L/usr/lib" -- Ensure library path is found
  elseif content:match("SDL2") or content:match("SDL.h") then
    table.insert(pkgs, "sdl2")
    -- Check for common SDL2 extensions
    if content:match("SDL_image.h") then table.insert(pkgs, "SDL2_image") end
    if content:match("SDL_ttf.h") then table.insert(pkgs, "SDL2_ttf") end
    if content:match("SDL_mixer.h") then table.insert(pkgs, "SDL2_mixer") end
  end

  -- Auto-detect 'include' directory
  if vim.fn.isdirectory("include") == 1 then
    extra_flags = extra_flags .. " -Iinclude"
  end

  local flags = ""
  if #pkgs > 0 then
    -- Get flags for all detected packages at once
    local pkg_str = table.concat(pkgs, " ")
    local pkg_out = vim.fn.system("pkg-config --cflags --libs " .. pkg_str)
    if vim.v.shell_error == 0 then
      flags = pkg_out:gsub("\n", " ")
    else
      print("Error running pkg-config for: " .. pkg_str)
    end
  end
  
  -- Combine extra flags (like manual -L) with pkg-config flags
  flags = extra_flags .. " " .. flags

  local debug_info = "echo 'Detected pkgs: " .. table.concat(pkgs, ", ") .. "'; "
  debug_info = debug_info .. "echo 'Flags: " .. flags .. "'; "

  local cmd = debug_info .. "g++ " .. file .. " " .. flags .. " -o " .. output .. " && ./" .. output
  vim.fn.termopen(cmd)
  
  -- Store the new buffer ID
  cpp_term_buf = vim.api.nvim_get_current_buf()
  
  -- Enter insert mode
  vim.cmd("startinsert")
end, { desc = "Run C++ File" })

-- Run Python
local py_term_buf = nil
map("n", "<leader>pr", function()
  -- If a terminal buffer exists and is valid, delete it
  if py_term_buf and vim.api.nvim_buf_is_valid(py_term_buf) then
    vim.api.nvim_buf_delete(py_term_buf, { force = true })
  end

  local file = vim.fn.expand("%")
  vim.cmd("w")
  
  -- Open a horizontal split at the bottom
  vim.cmd("botright 10new")
  
  local cmd = "python3 " .. file
  vim.fn.termopen(cmd)
  
  -- Store the new buffer ID
  py_term_buf = vim.api.nvim_get_current_buf()
  
  -- Enter insert mode
  vim.cmd("startinsert")
end, { desc = "Run Python File" })
