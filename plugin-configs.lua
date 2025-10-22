-- Plugin Configurations from Nixy NVF

-- Aerial (outline)
require("aerial").setup({})

-- Colorizer
require('colorizer').setup({
  filetypes = {},
  user_default_options = {}
})

-- Conform (formatting)
require("conform").setup({
  default_format_opts = { lsp_format = "fallback" },
  format_after_save = function()
    if not vim.g.formatsave or vim.b.disableFormatSave then
      return
    else
      return { lsp_format = "fallback" }
    end
  end,
  format_on_save = function()
    if not vim.g.formatsave or vim.b.disableFormatSave then
      return
    else
      return { lsp_format = "fallback", timeout_ms = 500 }
    end
  end,
  formatters = {
    deno_fmt = { command = "deno" },
    prettier = { command = "prettier" },
    shfmt = { command = "shfmt" }
  },
  formatters_by_ft = {
    astro = { "prettier" },
    css = { "prettier" },
    markdown = { "deno_fmt" },
    sh = { "shfmt" },
    svelte = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" }
  }
})

-- Copilot
require("copilot").setup({
  copilot_node_command = "node",
  panel = {
    enabled = false,
    keymap = {
      accept = false,
      jump_next = false,
      jump_prev = false,
      open = false,
      refresh = false
    },
    layout = {
      position = "bottom",
      ratio = 0.4
    }
  },
  suggestion = {
    enabled = false,
    keymap = {
      accept = false,
      accept_line = false,
      accept_word = false,
      dismiss = false,
      next = false,
      prev = false
    }
  }
})
require('copilot_cmp').setup()

-- Flash (motion)
require("flash").setup({})

-- Git Conflict
require('git-conflict').setup({ default_mappings = false })

-- Gitsigns
require('gitsigns').setup({})

-- LSP Signature
require("lsp_signature").setup({
  bind = false,
  handler_opts = { border = "rounded" }
})

-- Lualine
require('lualine').setup({
  extensions = {{
    filetypes = { "snacks_picker_list", "snacks_picker_input" },
    sections = {
      lualine_a = {
        function()
          return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
        end,
      }
    }
  }},
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  options = {
    always_divide_middle = true,
    component_separators = { "", "" },
    globalstatus = true,
    icons_enabled = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000
    },
    section_separators = { "", "" },
    theme = "catppuccin"
  },
  sections = {
    lualine_a = {{
      "mode",
      icons_enabled = true,
      separator = { left = '▎', right = '' },
    }, {
      "",
      draw_empty = true,
      separator = { left = '', right = '' }
    }},
    lualine_b = {{
      "filetype",
      colored = true,
      icon_only = true,
      icon = { align = 'left' }
    }, {
      "filename",
      symbols = { modified = ' ', readonly = ' ' },
      separator = { right = '' }
    }, {
      "",
      draw_empty = true,
      separator = { left = '', right = '' }
    }},
    lualine_c = {{
      "diff",
      colored = false,
      diff_color = {
        added = 'DiffAdd',
        modified = 'DiffChange',
        removed = 'DiffDelete',
      },
      symbols = { added = '+', modified = '~', removed = '-' },
      separator = { right = '' }
    }},
    lualine_x = {{
      function()
        local buf_ft = vim.bo.filetype
        local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }
        
        if excluded_buf_ft[buf_ft] then
          return ""
        end
        
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        
        if vim.tbl_isempty(clients) then
          return "No Active LSP"
        end
        
        local active_clients = {}
        for _, client in ipairs(clients) do
          table.insert(active_clients, client.name)
        end
        
        return table.concat(active_clients, ", ")
      end,
      icon = ' ',
      separator = { left = '' },
    }, {
      "diagnostics",
      sources = { 'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp', 'coc' },
      symbols = { error = '󰅙  ', warn = '  ', info = '  ', hint = '󰌵 ' },
      colored = true,
      update_in_insert = false,
      always_visible = false,
      diagnostics_color = {
        color_error = { fg = 'red' },
        color_warn = { fg = 'yellow' },
        color_info = { fg = 'cyan' },
      },
    }},
    lualine_y = {{
      "",
      draw_empty = true,
      separator = { left = '', right = '' }
    }, {
      'searchcount',
      maxcount = 999,
      timeout = 120,
      separator = { left = '' }
    }, {
      "branch",
      icon = ' •',
      separator = { left = '' }
    }},
    lualine_z = {{
      "",
      draw_empty = true,
      separator = { left = '', right = '' }
    }, {
      "progress",
      separator = { left = '' }
    }, { "location" }, {
      "fileformat",
      color = { fg = 'black' },
      symbols = {
        unix = '',
        dos = '',
        mac = '',
      }
    }}
  }
})

-- LSPSaga
require("lspsaga").setup({
  border_style = "rounded",
  breadcrumbs = { enable = false },
  lightbulb = {
    sign = false,
    virtual_text = true
  },
  ui = { code_action = "" }
})

-- LuaSnip
require("luasnip").setup({ enable_autosnippets = false })

-- Markview
require("markview").setup({})

-- Mini modules
require("mini.comment").setup({})
require("mini.diff").setup({})
require("mini.git").setup({})
require("mini.icons").setup({})
require("mini.indentscope").setup({
  ignore_filetypes = { "help", "neo-tree", "notify", "NvimTree", "TelescopePrompt" }
})
require("mini.notify").setup({
  window = { config = { border = "rounded" } }
})
vim.notify = MiniNotify.make_notify({
  DEBUG = { duration = 0, hl_group = "DiagnosticHint" },
  ERROR = { duration = 5000, hl_group = "DiagnosticError" },
  INFO = { duration = 5000, hl_group = "DiagnosticInfo" },
  OFF = { duration = 0, hl_group = "MiniNotifyNormal" },
  TRACE = { duration = 0, hl_group = "DiagnosticOk" },
  WARN = { duration = 5000, hl_group = "DiagnosticWarn" }
})
require("mini.pairs").setup({})
require("mini.starter").setup({})

-- Noice
require("noice").setup({
  format = {
    cmdline = { icon = "", lang = "vim", pattern = "^:" },
    filter = { icon = "", lang = "bash", pattern = "^:%s*!" },
    help = { icon = "󰋖", pattern = "^:%s*he?l?p?%s+" },
    lua = { icon = "", lang = "lua", pattern = "^:%s*lua%s+" },
    search_down = { icon = " ", kind = "search", lang = "regex", pattern = "^/" },
    search_up = { icon = " ", kind = "search", lang = "regex", pattern = "^%?" }
  },
  lsp = {
    override = {
      ["cmp.entry.get_documentation"] = true,
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true
    },
    signature = { enabled = false }
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    inc_rename = false,
    long_message_to_split = true,
    lsp_doc_border = false
  },
  routes = {{
    filter = { event = "msg_show", find = "written", kind = "" },
    opts = { skip = true }
  }}
})

-- Null-ls
require('null-ls').setup({
  debounce = 250,
  debug = false,
  default_timeout = 5000,
  diagnostics_format = "[#{m}] #{s} (#{c})",
  on_attach = on_attach
})

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require('luasnip')

cmp.setup({
  completion = { completeopt = "menu,menuone,noinsert" },
  formatting = {
    format = require("lspkind").cmp_format({
      before = function(entry, vim_item)
        vim_item.menu = ({
          buffer = "[Buffer]",
          copilot = "[Copilot]",
          luasnip = "[LuaSnip]",
          nvim_lsp = "[LSP]",
          path = "[Path]",
          treesitter = "[Treesitter]"
        })[entry.source.name]
        return vim_item
      end,
      mode = "symbol_text"
    })
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),
    ["<Tab>"] = cmp.mapping(function(fallback)
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end)
  },
  sources = {
    { name = "buffer" },
    { name = "copilot" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "treesitter" }
  }
})

-- nvim-dap
local dap = require("dap")
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "ErrorMsg", linehl = "", numhl = "" })

-- nvim-dap-go
require('dap-go').setup({
  delve = { path = 'dlv' }
})

-- nvim-lint
require("lint").linters_by_ft = {
  astro = { "eslint_d" },
  markdown = { "markdownlint-cli2" },
  nix = { "statix", "deadnix" },
  sh = { "shellcheck" },
  svelte = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" }
}

-- nvim-web-devicons
require("nvim-web-devicons").setup({
  color_icons = true,
  override = {}
})

-- Bufferline
require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    always_show_bufferline = true,
    auto_toggle_bufferline = true,
    buffer_close_icon = " 󰅖 ",
    close_command = function(bufnum)
      require("bufdelete").bufdelete(bufnum, false)
    end,
    close_icon = "  ",
    color_icons = true,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and "   "
          or (e == "warning" and "   " or "  ")
        s = s .. n .. sym
      end
      return s
    end,
    diagnostics_update_in_insert = false,
    duplicates_across_groups = true,
    enforce_regular_tabs = false,
    hover = { delay = 200, enabled = true, reveal = { "close" } },
    indicator = { style = "underline" },
    left_mouse_command = "buffer %d",
    left_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    mode = "buffers",
    modified_icon = "● ",
    move_wraps_at_ends = false,
    numbers = function(opts)
      return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
    end,
    offsets = {
      { filetype = "NvimTree", highlight = "Directory", separator = true, text = "File Explorer" },
      { filetype = "neo-tree", highlight = "Directory", separator = true, text = "File Explorer" },
      { filetype = "snacks_layout_box", highlight = "Directory", separator = true, text = "File Explorer" }
    },
    persist_buffer_sort = true,
    right_mouse_command = "vertical sbuffer %d",
    right_trunc_marker = "",
    separator_style = "thin",
    show_buffer_close_icons = true,
    show_buffer_icons = true,
    show_close_icon = true,
    show_duplicate_prefix = true,
    show_tab_indicators = true,
    sort_by = "extension",
    style_preset = require('bufferline').style_preset.default,
    tab_size = 18,
    themable = true,
    truncate_names = true
  }
})

-- Oil
require("oil").setup({})

-- Otter
require("otter").setup({
  buffers = { set_filetype = true, write_to_disk = false },
  handle_leading_whitespace = false,
  lsp = { diagnostic_update_event = { "BufWritePost", "InsertLeave" } },
  strip_wrapping_quote_characters = { "'", '"', "`" }
})

-- Rainbow Delimiters
vim.g.rainbow_delimiters = {}

-- Snacks
require("snacks").setup({
  bufdelete = { enabled = true },
  explorer = { enabled = true },
  gitsigns = { enabled = true },
  image = { enabled = true, setupOpts = { doc = { inline = false } } },
  picker = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  zen = { enabled = true }
})

-- Todo Comments
require('todo-comments').setup({
  highlight = { pattern = ".*<(KEYWORDS)(\\([^\\)]*\\))?:" },
  search = {
    args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
    command = "rg",
    pattern = "\\b(KEYWORDS)(\\([^\\)]*\\))?:"
  }
})

-- ToggleTerm
require("toggleterm").setup({
  direction = "horizontal",
  enable_winbar = false,
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  winbar = {
    enabled = true,
    name_formatter = function(term)
      return term.name
    end
  }
})

-- Treesitter
require('nvim-treesitter.configs').setup({
  auto_install = false,
  sync_install = false,
  ensure_installed = {},
  indent = { enable = true, disable = {} },
  highlight = { enable = true, disable = {}, additional_vim_regex_highlighting = false },
  incremental_selection = {
    enable = true,
    disable = {},
    keymaps = {
      init_selection = false,
      node_incremental = false,
      scope_incremental = false,
      node_decremental = false,
    },
  },
})

-- Treesitter Context
require("treesitter-context").setup({
  line_numbers = true,
  max_lines = 0,
  min_window_height = 0,
  mode = "cursor",
  multiline_threshold = 20,
  separator = "-",
  trim_scope = "outer",
  zindex = 20
})

-- TS Error Translator
require("ts-error-translator").setup({
  auto_override_publish_diagnostics = true
})

-- Trouble
require("trouble").setup({})

-- Which Key
local wk = require("which-key")
wk.setup({
  notify = true,
  preset = "modern",
  replace = {
    ["<cr>"] = "RETURN",
    ["<leader>"] = "SPACE",
    ["<space>"] = "SPACE",
    ["<tab>"] = "TAB"
  },
  win = { border = "rounded" }
})
wk.add({
  { '<leader>b', desc = '+Buffer' },
  { '<leader>bm', desc = 'BufferLineMove' },
  { '<leader>bs', desc = 'BufferLineSort' },
  { '<leader>bsi', desc = 'BufferLineSortById' },
  { '<leader>g', desc = '+Gitsigns' },
  { '<leader>lw', desc = '+Workspace' },
  { '<leader>x', desc = '+Trouble' }
})
