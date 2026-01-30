return {
  -- Colorscheme
  {
    "tahayvr/matteblack.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme matteblack]])
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
        },
      })
    end,
  },

  -- Bufferline (Tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "left",
              separator = true,
            },
          },
        },
      })
    end,
  },

  -- File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    },
    config = function()
      require("neo-tree").setup({
        window = {
            width = 30,
        },
      })
    end,
  },

  -- Symbol Outline
  {
    "stevearc/aerial.nvim",
    lazy = false,
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>a", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
    },
    config = function()
      require("aerial").setup({
        -- Use symbol outline for the whole editor, not just the current window
        attach_mode = "global",
        layout = {
          default_direction = "right",
          placement = "edge",
        },
        close_on_select = false,
        -- Don't show errors if symbols aren't found for these
        ignore = {
            filetypes = { "neo-tree", "alpha", "NvimTree", "TelescopePrompt" },
        },
        -- Customize the content of the status line
        show_guides = true,
      })
    end,
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    },
  },
  
  -- Dashboard (Intro Page)
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        [[ ██▓     ▒█████   ▒█████    ██████ ▓█████  ██▀███  ]],
        [[▓██▒    ▒██▒  ██▒▒██▒  ██▒▒██    ▒ ▓█   ▀ ▓██ ▒ ██▒]],
        [[▒██░    ▒██░  ██▒▒██░  ██▒░ ▓██▄   ▒███   ▓██ ░▄█ ▒]],
        [[▒██░    ▒██   ██░▒██   ██░  ▒   ██▒▒▓█  ▄ ▒██▀▀█▄  ]],
        [[░██████▒░ ████▓▒░░ ████▓▒░▒██████▒▒░▒████▒░██▓ ▒██▒]],
        [[░ ▒░▓  ░░ ▒░▒░▒░ ░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ▒▓ ░▒▓░]],
        [[░ ░ ▒  ░  ░ ▒ ▒░   ░ ▒ ▒░ ░ ░▒  ░ ░ ░ ░  ░  ░▒ ░ ▒░]],
        [[  ░ ░   ░ ░ ░ ▒  ░ ░ ░ ▒  ░  ░  ░     ░     ░░   ░ ]],
        [[    ░  ░    ░ ░      ░ ░        ░     ░  ░   ░     ]],
        [[                                                   ]],
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      require("alpha").setup(dashboard.opts)
    end,
  },

  -- Which Key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {}
  }
}
