-- Nixy NVF Neovim Configuration Export
-- This file contains the rendered configuration from your Nix flake
-- Use this as a reference to port features to a regular Lua-based config

-- ============================================================================
-- BASIC OPTIONS
-- ============================================================================
vim.o.autoindent = true
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 1
vim.o.cursorlineopt = "line"
vim.o.encoding = "utf-8"
vim.o.errorbells = false
vim.o.expandtab = true
vim.o.fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵"
vim.o.foldcolumn = "auto:1"
vim.o.foldlevel = 99
vim.o.hidden = true
vim.o.mouse = "nvi"
vim.o.mousemoveevent = true
vim.o.mousescroll = "ver:1,hor:1"
vim.o.number = true
vim.o.shiftwidth = 2
vim.o.signcolumn = "yes"
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.tm = 500
vim.o.undodir = vim.fn.stdpath('state') .. '/undo'
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.visualbell = false
vim.o.wrap = false
vim.o.writebackup = false

-- ============================================================================
-- GLOBAL VARIABLES
-- ============================================================================
vim.g.mapleader = " "
vim.g.navic_silence = true
vim.g.suda_smart_edit = 1
vim.g.neovide_scale_factor = 0.7
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_short_animation_length = 0
vim.g.formatsave = true

-- ============================================================================
-- DIAGNOSTICS CONFIGURATION
-- ============================================================================
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    }
  },
  underline = true,
  update_in_insert = true,
  virtual_lines = false,
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s", diagnostic.message)
    end
  }
})

-- ============================================================================
-- KEY MAPPINGS
-- ============================================================================

-- General Mappings
vim.keymap.set("n", "s", "<cmd>lua require('flash').jump()<cr>", { desc = "Flash", silent = true })
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "LSP Hover", silent = true })
vim.keymap.set("n", "<C-tab>", "<cmd>bnext<cr>", { desc = "Next Buffer", silent = true })

-- Kitty Navigator
vim.keymap.set("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", { silent = true })
vim.keymap.set("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", { silent = true })
vim.keymap.set("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", { silent = true })
vim.keymap.set("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", { silent = true })

-- Disable Arrow Keys
vim.keymap.set("n", "<Up>", "<Nop>", { desc = "Disable Up Arrow", silent = true })
vim.keymap.set("n", "<Down>", "<Nop>", { desc = "Disable Down Arrow", silent = true })
vim.keymap.set("n", "<Left>", "<Nop>", { desc = "Disable Left Arrow", silent = true })
vim.keymap.set("n", "<Right>", "<Nop>", { desc = "Disable Right Arrow", silent = true })

-- UI Toggles
vim.keymap.set("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrapping", silent = true })
vim.keymap.set("n", "<leader>ul", "<cmd>set linebreak!<cr>", { desc = "Toggle linebreak", silent = true })
vim.keymap.set("n", "<leader>us", "<cmd>set spell!<cr>", { desc = "Toggle spellcheck", silent = true })
vim.keymap.set("n", "<leader>uc", "<cmd>set cursorline!<cr>", { desc = "Toggle cursorline", silent = true })
vim.keymap.set("n", "<leader>un", "<cmd>set number!<cr>", { desc = "Toggle line numbers", silent = true })
vim.keymap.set("n", "<leader>ur", "<cmd>set relativenumber!<cr>", { desc = "Toggle relative line numbers", silent = true })
vim.keymap.set("n", "<leader>ut", "<cmd>set showtabline=2<cr>", { desc = "Show tabline", silent = true })
vim.keymap.set("n", "<leader>uT", "<cmd>set showtabline=0<cr>", { desc = "Hide tabline", silent = true })

-- Windows
vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split", silent = true })
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "VSplit", silent = true })
vim.keymap.set("n", "<leader>wd", "<cmd>close<cr>", { desc = "Close", silent = true })

-- File Explorer
vim.keymap.set("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", { desc = "File Explorer", silent = true })
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil", silent = true })

-- Picker/Finder Mappings (using Snacks)
vim.keymap.set("n", "<leader> ", "<cmd>lua Snacks.picker.smart()<cr>", { desc = "Smart Find Files", silent = true })
vim.keymap.set("n", "<leader>,", "<cmd>lua Snacks.picker.buffers()<cr>", { desc = "Buffers", silent = true })
vim.keymap.set("n", "<leader>/", "<cmd>lua Snacks.picker.grep()<cr>", { desc = "Grep", silent = true })
vim.keymap.set("n", "<leader>:", "<cmd>lua Snacks.picker.command_history()<cr>", { desc = "Command History", silent = true })

-- Find Files
vim.keymap.set("n", "<leader>fb", "<cmd>lua Snacks.picker.buffers()<cr>", { desc = "Buffers", silent = true })
vim.keymap.set("n", "<leader>fc", "<cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<cr>", { desc = "Find Config File", silent = true })
vim.keymap.set("n", "<leader>ff", "<cmd>lua Snacks.picker.files()<cr>", { desc = "Find Files", silent = true })
vim.keymap.set("n", "<leader>fg", "<cmd>lua Snacks.picker.git_files()<cr>", { desc = "Find Git Files", silent = true })
vim.keymap.set("n", "<leader>fp", "<cmd>lua Snacks.picker.projects()<cr>", { desc = "Projects", silent = true })
vim.keymap.set("n", "<leader>fr", "<cmd>lua Snacks.picker.recent()<cr>", { desc = "Recent", silent = true })
vim.keymap.set("n", "<leader>fn", "<cmd>lua Snacks.picker.notifications()<cr>", { desc = "Notification History", silent = true })
vim.keymap.set("n", "<leader>fe", "<cmd>lua Snacks.picker.icons()<cr>", { desc = "Emoji", silent = true })

-- Git
vim.keymap.set("n", "<leader>gb", "<cmd>lua Snacks.picker.git_branches()<cr>", { desc = "Git Branches", silent = true })
vim.keymap.set("n", "<leader>gL", "<cmd>lua Snacks.picker.git_log()<cr>", { desc = "Git Log Line", silent = true })
vim.keymap.set("n", "<leader>gs", "<cmd>lua Snacks.picker.git_status()<cr>", { desc = "Git Status", silent = true })
vim.keymap.set("n", "<leader>gS", "<cmd>lua Snacks.picker.git_stash()<cr>", { desc = "Git Stash", silent = true })
vim.keymap.set("n", "<leader>gd", "<cmd>lua Snacks.picker.git_diff()<cr>", { desc = "Git Diff (Hunks)", silent = true })
vim.keymap.set("n", "<leader>gf", "<cmd>lua Snacks.picker.git_log_file()<cr>", { desc = "Git Log File", silent = true })

-- Search/Grep
vim.keymap.set("n", "<leader>sb", "<cmd>lua Snacks.picker.lines()<cr>", { desc = "Buffer Lines", silent = true })
vim.keymap.set("n", "<leader>st", "<cmd>lua Snacks.picker.todo_comments()<cr>", { desc = "Todos", silent = true })
vim.keymap.set("n", "<leader>sB", "<cmd>lua Snacks.picker.grep_buffers()<cr>", { desc = "Grep Open Buffers", silent = true })
vim.keymap.set("n", "<leader>sg", "<cmd>lua Snacks.picker.grep()<cr>", { desc = "Grep", silent = true })
vim.keymap.set("n", "<leader>sw", "<cmd>lua Snacks.picker.grep_word()<cr>", { desc = "Visual selection or word", silent = true })
vim.keymap.set("n", "<leader>sr", "<cmd>nohlsearch<cr>", { desc = "Reset search", silent = true })

-- LSP Navigation
vim.keymap.set("n", "gd", "<cmd>lua Snacks.picker.lsp_definitions()<cr>", { desc = "Goto Definition", silent = true })
vim.keymap.set("n", "gD", "<cmd>lua Snacks.picker.lsp_declarations()<cr>", { desc = "Goto Declaration", silent = true })
vim.keymap.set("n", "gr", "<cmd>lua Snacks.picker.lsp_references()<cr>", { desc = "References", silent = true, nowait = true })
vim.keymap.set("n", "gI", "<cmd>lua Snacks.picker.lsp_implementations()<cr>", { desc = "Goto Implementation", silent = true })
vim.keymap.set("n", "gy", "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>", { desc = "Goto Type Definition", silent = true })
vim.keymap.set("n", "<leader>ss", "<cmd>lua Snacks.picker.lsp_symbols()<cr>", { desc = "LSP Symbols", silent = true })
vim.keymap.set("n", "<leader>sS", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>", { desc = "LSP Workspace Symbols", silent = true })

-- LazyGit
vim.keymap.set("n", "<leader>gl", function() 
  -- This would need to be adapted for your terminal setup
  -- Original uses toggleterm with lazygit
end, { desc = "Open lazygit", silent = true })

-- ============================================================================
-- PLUGIN CONFIGURATIONS
-- ============================================================================

-- Note: The following are the main plugins used in your config.
-- You'll need to install these via your preferred plugin manager (lazy.nvim, packer, etc.)

--[[
Main Plugins Used:
- nvim-treesitter/nvim-treesitter
- neovim/nvim-lspconfig
- hrsh7th/nvim-cmp
- L3MON4D3/LuaSnip
- folke/snacks.nvim (for picker/explorer)
- stevearc/oil.nvim
- folke/flash.nvim
- lewis6991/gitsigns.nvim
- nvim-lualine/lualine.nvim
- akinsho/bufferline.nvim
- folke/trouble.nvim
- folke/which-key.nvim
- github/copilot.vim or zbirenbaum/copilot.lua
- folke/todo-comments.nvim
- echasnovski/mini.nvim (multiple modules)
- folke/noice.nvim
- nvim-treesitter/nvim-treesitter-context
- akinsho/toggleterm.nvim
- mfussenegger/nvim-dap
- leoluz/nvim-dap-go
- nvim-lint
- stevearc/conform.nvim
- catppuccin/nvim (theme)
--]]

-- ============================================================================
-- LSP CONFIGURATION TEMPLATE
-- ============================================================================

-- LSP attach function
local function attach_keymaps(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  vim.keymap.set('n', '<leader>lgD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
  vim.keymap.set('n', '<leader>lgd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
  vim.keymap.set('n', '<leader>lgt', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Go to type' }))
  vim.keymap.set('n', '<leader>lgi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'List implementations' }))
  vim.keymap.set('n', '<leader>lgr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'List references' }))
  vim.keymap.set('n', '<leader>lgn', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Go to next diagnostic' }))
  vim.keymap.set('n', '<leader>lgp', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Go to previous diagnostic' }))
  vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Open diagnostic float' }))
  vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Trigger hover' }))
  vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))
  vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
  vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
  vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = 'Format' }))
end

-- Default capabilities for LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- ============================================================================
-- LANGUAGE SERVERS CONFIGURED
-- ============================================================================
--[[
The following language servers are configured in your setup:
- astro (Astro)
- bashls (Bash)
- cssls (CSS)
- gopls (Go)
- marksman (Markdown)
- nil_ls (Nix)
- svelte (Svelte)
- tailwindcss (Tailwind CSS)
- ts_ls (TypeScript/JavaScript)

Example LSP setup (you'll need lspconfig):
require('lspconfig').ts_ls.setup({
  capabilities = capabilities,
  on_attach = attach_keymaps,
})
--]]

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================

-- Lint on save
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function(args)
    -- Your linting logic here
  end,
})

-- LSP inlay hints
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end
  end,
})

-- ============================================================================
-- THEME CONFIGURATION
-- ============================================================================
--[[
Your config uses Catppuccin theme with:
- Style: mocha
- Transparent background: true

Example setup:
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
})
vim.cmd.colorscheme "catppuccin"
--]]

-- ============================================================================
-- NOTES FOR PORTING
-- ============================================================================
--[[
Key features to port:
1. Snacks.nvim for file picking/exploration (alternative: telescope.nvim)
2. Flash.nvim for quick navigation
3. Oil.nvim for file editing
4. Comprehensive LSP setup with multiple language servers
5. Copilot integration
6. Git integration with gitsigns
7. DAP (Debug Adapter Protocol) setup
8. Linting with nvim-lint
9. Formatting with conform.nvim
10. Mini.nvim modules for various utilities
11. Bufferline and lualine for UI
12. Which-key for keybinding help
13. Trouble.nvim for diagnostics
14. Todo-comments for TODO highlighting
15. Treesitter for syntax highlighting
16. Noice.nvim for enhanced UI

The configuration is quite comprehensive and modern, using lazy loading
and efficient plugin management.
--]]
