# Gemini Context: Neovim Configuration

## Project Overview
This directory contains a **Neovim configuration** tailored for **C++ development**. It is built using the **LazyVim** structure (though customized) and utilizes **lazy.nvim** as the plugin manager. The configuration provides a modern development environment with features like LSP (Language Server Protocol), debugging, formatting, and a rich UI including a custom dashboard and symbol outline.

## Architecture & Structure
The project follows a standard Neovim Lua configuration structure:

- **`init.lua`**: The entry point. It loads options, keymaps, autocmds, and the lazy plugin manager.
- **`lua/`**: Contains all the Lua code.
    - **`config/`**: Core configuration files.
        - `options.lua`: Vim options (settings).
        - `keymaps.lua`: General keybindings.
        - `autocmds.lua`: Automation (Startup layout with sidebars and dashboard).
        - `lazy.lua`: Bootstrapping and configuration for the `lazy.nvim` plugin manager.
    - **`plugins/`**: Plugin specifications and configurations.
        - `lsp.lua`: Language Server Protocol setup (Mason, nvim-lspconfig, clangd).
        - `cmp.lua`: Autocompletion (nvim-cmp, LuaSnip, cmdline completion).
        - `treesitter.lua`: Syntax highlighting and parsing.
        - `ui.lua`: User interface (Matte Black theme, Lualine, Neo-tree, Telescope, Aerial, Alpha Dashboard).
        - `formatting.lua`: Auto-formatting (conform.nvim).
        - `dap.lua`: Debug Adapter Protocol (nvim-dap, nvim-dap-ui, codelldb).

## Key Components

### C++ Development Stack
- **LSP**: `clangd` (via `mason.nvim` and `nvim-lspconfig`).
- **Debugging**: `codelldb` (via `nvim-dap` and `mason-nvim-dap`).
- **Formatting**: `clang-format` (via `conform.nvim`).
- **Syntax**: `nvim-treesitter` with C/C++ parsers.

### Enhanced UI
- **Dashboard**: `alpha-nvim` with custom "LOOSER" ASCII art (sourced from `asci.txt`).
- **File Explorer**: `neo-tree.nvim` (opens automatically on left).
- **Symbol Outline**: `aerial.nvim` (opens automatically on right, provides function/class listing).
- **Completion**: `nvim-cmp` with `cmp-cmdline` for `:` and `/` support.

### Plugin Management
- **Manager**: `lazy.nvim`
- **Behavior**: Plugins are installed to `~/.local/share/nvim/lazy`. `lazy.lua` handles bootstrapping.

## Usage

### Installation
1.  Ensure **Neovim** (v0.9.0+) is installed.
2.  Ensure external tools: `gcc`/`clang`, `ripgrep`, `git`.
3.  Start Neovim: `nvim`
4.  Wait for `lazy.nvim` to install plugins.

### Key Commands (Leader = Space)
- **File Explorer**: `<Space>e`
- **Find Files**: `<Space>ff`
- **Live Grep**: `<Space>fg`
- **Symbol Outline**: `<Space>a`
- **LSP Actions**:
    - `gd`: Go to definition
    - `K`: Hover documentation
    - `<Space>rn`: Rename
- **Debugging**:
    - `<Space>db`: Toggle breakpoint
    - `<Space>dc`: Continue/Start
- **Formatting**: `<Space>mp` (or auto-save)
- **Lazy Manager**: `<Space>l`

## Development Conventions
- **Language**: Lua
- **Startup Logic**: Handled in `lua/config/autocmds.lua` to manage sidebars and dashboard focus.
- **Style**: Modular configuration split by concern in `lua/plugins/*.lua`.
- **Formatting**: Stylua is used for Lua files.