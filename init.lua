-- ========================================================================== --
-- ==                           1. CORE SETTINGS                           == --
-- ========================================================================== --
-- This section is for standard Vim settings (line numbers, tabs, etc.)

-- FIX: Suppress the annoying "deprecated" warning you saw earlier
vim.g.lspconfig_suppress_deprecation_warnings = true
vim.env.NVIM_LSPCONFIG_SUPPRESS_DEPRO_WARNINGS = "1"

-- LINE NUMBERS: "Hybrid" mode (Absolute line number where you are, relative for others)
vim.opt.number = true
vim.opt.relativenumber = true

-- VISUALS
vim.opt.signcolumn = "yes" -- Always show the gutter on the left (prevents shifting)
vim.opt.termguicolors = true -- Better colors

-- INDENTATION (Standard 4-space tab)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- KEYMAPS
-- Map <Esc> to exit terminal mode easily
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- UI ICONS
-- This changes the ugly letters (E, W, H) in the sidebar to clean spaces/icons
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


-- ========================================================================== --
-- ==                       2. BOOTSTRAP LAZY.NVIM                         == --
-- ========================================================================== --
-- You typically NEVER touch this. This code installs the "Lazy" plugin manager
-- if it is missing.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)


-- ========================================================================== --
-- ==                       3. PLUGIN CONFIGURATION                        == --
-- ========================================================================== --
-- THIS IS WHERE YOU LIVE.
-- Every plugin is a table {} inside the setup list.

require("lazy").setup({

  -- [[ THEME PLUGIN ]] --------------------------------------------------------
  { 
    "bluz71/vim-moonfly-colors", 
    name = "moonfly", 
    lazy = false, 
    priority = 1000 
  },

  -- [[ LATEX PLUGIN (VimTeX) ]] ----------------------------------------------
  {
    "lervag/vimtex",
    lazy = false, -- essential for VimTeX to work
    init = function()
      -- These settings happen BEFORE the plugin loads
      vim.g.vimtex_view_method = 'zathura'   -- Uses Zathura PDF viewer
      vim.g.vimtex_compiler_method = 'latexmk' -- Uses latexmk engine
      vim.g.vimtex_quickfix_mode = 0
    end
  },

  -- [[ AUTOCOMPLETE ENGINE (nvim-cmp) ]] -------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- connects cmp to LSP
      "hrsh7th/cmp-buffer",   -- suggests words in current file
      "L3MON4D3/LuaSnip",     -- snippet engine
      "saadparwaiz1/cmp_luasnip",
      "micangl/cmp-vimtex", -- Latex
    },
    config = function()
      -- This function runs AFTER the plugin loads to set it up
      local cmp = require('cmp')
      cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(), -- Tab to go down list
          ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Shift+Tab to go up
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Enter to select
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vimtex' },
            { name = 'buffer' }
        })
      })
    end
  },

  -- [[ LANGUAGE SERVER MANAGER (LSP) ]] --------------------------------------
  -- This handles Python, Lua, C++, Bash, etc.
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- 1. Setup Mason (The tool that downloads servers)
      require("mason").setup()
      -- 2. Setup Mason-LSPConfig (The tool that connects Mason to Neovim)
      require("mason-lspconfig").setup({  
        -- LIST OF SERVERS TO INSTALL AUTOMATICALLY:
        ensure_installed = { 
            "pyright", -- Python
            "lua_ls",  -- Lua
            "ruff",    -- Python Linting
            "bashls",  -- Bash
            "clangd"   -- C/C++
        },

        -- AUTOMATIC HANDLERS
        -- This code automatically sets up every server in the list above.
        -- You do NOT need to manually type "lspconfig.pyright.setup{}" anymore.
        handlers = {
          -- Default handler: Setup the server with default settings
          function(server_name)
            require("lspconfig")[server_name].setup {}
          end,

          -- Custom handler for Lua (fixes the annoying 'global vim' warning)
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup {
              settings = {
                Lua = { diagnostics = { globals = { 'vim' } } }
              }
            }
          end,
        }
      })
    end
  },

  -- [[ PLACE NEW PLUGINS BELOW THIS LINE ]] ----------------------------------
  -- Example: { "author/plugin-name", config = function() ... end },
  
  
  -- [[ END OF PLUGINS ]] -----------------------------------------------------
})


-- ========================================================================== --
-- ==                        4. FINAL UI POLISH                            == --
-- ========================================================================== --
-- Apply the colorscheme after plugins are loaded
vim.cmd([[colorscheme moonfly]])

-- Configure how errors look (text inside the file)
vim.diagnostic.config({ virtual_text = true })
