_G.nvim_start_time = vim.loop.hrtime()
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- "https://github.com/nvimdev/dashboard-nvim",
  "https://github.com/rktjmp/hotpot.nvim",
  "https://github.com/udayvir-singh/hibiscus.nvim",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master"
  },
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-treesitter/playground",
  "https://github.com/nvim-treesitter/nvim-treesitter-context"
})


vim.cmd [[packadd cfilter]]

require 'nvim-treesitter.configs'.setup {
  modules = {},
  ignore_install = {},
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  sync_install = false,
  auto_install = false,
  -- ignore_install = { "javascript" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection    = '<A-o>', -- start selection
      node_incremental  = '<A-o>', -- expand to parent
      node_decremental  = '<A-i>', -- shrink
      scope_incremental = '<A-s>', -- optional (you could also map to A-p or disable)
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "Select around a function" },
        ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
        ["ac"] = { query = "@class.outer", desc = "Select around a class region" },
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>ma"] = "@parameter.inner",
        ["<leader>mf"] = "@function.outer",
      },
      swap_previous = {
        ["<leader>mA"] = "@parameter.inner",
        ["<leader>mF"] = "@function.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,       -- whether to set jumps in the jumplist
      goto_next_start = {
        ['<A-n>'] = '@node',  -- next sibling
        ['<A-f>'] = '@child', -- first child
        ["]m"] = "@function.outer",
        ["]c"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        ["]]"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]C"] = "@class.outer",
        ["]O"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        ["]}"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_previous_start = {
        ['<A-p>'] = '@node',   -- previous sibling
        ['<A-b>'] = '@parent', -- parent node
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        ["[["] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[C"] = "@class.outer",
        ["[O"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        ["[{"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["[Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next = {
        ["]e"] = "@conditional.outer",
      },
      goto_previous = {
        ["[e"] = "@conditional.outer",
      }
    },
    lsp_interop = {
      enable = true,
      border = 'rounded',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>pf"] = "@function.outer",
        ["<leader>pc"] = "@class.outer",
        ["<leader>pi"] = "@indentifier.outer",
      },
    },
  },
}

require 'treesitter-context'.setup {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false,      -- Enable multiwindow support.
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

require("hotpot").setup({
  provide_require_fennel = true,
  enable_hotpot_diagnostics = true
})

-- require("custom-dashboard")
require("options")
require("mappings")
require("lsp")
require("plugins")
require("user_commands")
require("autocommands")
vim.cmd [[
set path+=,**
]]

local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
local string = vim.api.nvim_get_hl(0, { name = "String" })

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none", fg = normal.fg })
-- vim.api.nvim_set_hl(0, "NormalNC", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "EdgyNormal", { link = "Normal" })
-- vim.api.nvim_set_hl(0, "EdgyWinBar", { bg = "none", fg = normal.fg })
-- vim.api.nvim_set_hl(0, "EdgyIcon", { bg = "none", fg = normal.fg })
-- vim.api.nvim_set_hl(0, "EdgyIconActive", { bg = "none", fg = normal.fg })
-- vim.api.nvim_set_hl(0, "EdgyTitle", { bg = "none", fg = normal.fg })
-- vim.api.nvim_set_hl(0, "EdgyWinBarNC", { bg = "none", fg = normal.fg })
vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
vim.api.nvim_set_hl(0, "FoldColumn", { link = "Normal" })
vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
vim.api.nvim_set_hl(0, "WinBarNC", { link = "Normal" })
vim.api.nvim_set_hl(0, "LineNrAbove", { link = "Normal" })
vim.api.nvim_set_hl(0, "LineNr", { link = "String", bold = true })
vim.api.nvim_set_hl(0, "Folded", { link = "LineNr" })
vim.api.nvim_set_hl(0, "LineNrBelow", { link = "Normal" })


vim.api.nvim_set_hl(0, "lualine_b_normal", { bg = "none" })
vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = "none" })
vim.api.nvim_set_hl(0, "lualine_x_normal", { bg = "none" })
vim.api.nvim_set_hl(0, "lualine_y_normal", { bg = "none" })
vim.api.nvim_set_hl(0, "lualine_z_normal", { bg = "none" })

-- Do the same for inactive mode if needed:
vim.api.nvim_set_hl(0, "lualine_c_inactive", { bg = "none" })


-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "snacks_dashboard" }, -- replace with your filetypes
--   callback = function()
--     local o = vim.o
--     o.winborder = "none"
--   end,
-- })
--
_G.get_terminal_list = function()
  local list = Snacks.terminal.list()
  local gotten_list = vim.tbl_map(function(item)
    return { buf = item.buf, cmd = item.cmd }
  end, list)
  if #gotten_list == 0 then
    return
  end
  vim.ui.select(gotten_list, {
    prompt = "Select terminal",
    format_item = function(item)
      return item.cmd .. " " .. "(" .. item.buf .. ")"
    end,
  }, function(item)
    if not item then
      return
    end
    Snacks.terminal.toggle(item.cmd)
  end)
end

-- Extra plugins from lua/
require("plugins.avante")
require("plugins.heirline")

-- Snacks.terminal.toggle("zsh")
