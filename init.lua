-- MUST BE AT THE VERY TOP
vim.g.lspconfig_suppress_deprecation_warnings = true
vim.env.NVIM_LSPCONFIG_SUPPRESS_DEPRO_WARNINGS = "1"
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.diagnostic.config({ virtual_text = true })

-- 1. HYBRID LINE NUMBERS & SETTINGS
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Corrected Sign Define
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- 2. BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. CONFIGURE PLUGINS
require("lazy").setup({
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

  -- Autocomplete Engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ { name = 'nvim_lsp' } }, { { name = 'buffer' } })
      })
    end
  },

-- LSP Manager
{
  "neovim/nvim-lspconfig",
  dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({ 
      ensure_installed = { "pyright", "lua_ls", "ruff", "bashls", "clangd" } 
    })

    -- Enable the configs (this replaces setup calls)
    vim.lsp.enable('pyright') -- Python Autocomplete
    vim.lsp.enable('ruff')    -- Python linting
    vim.lsp.enable('lua_ls')  -- Lua support
    vim.lsp.enable('bashls')  -- Bash support
    vim.lsp.enable('clangd')  -- C/C++ support




-- Customize specific servers using vim.lsp.config
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
        },
      },
    })
  end
},

})

-- 4. LOAD THEME
vim.cmd([[colorscheme moonfly]])
