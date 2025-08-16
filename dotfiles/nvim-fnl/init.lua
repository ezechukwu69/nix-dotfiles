_G.nvim_start_time = vim.loop.hrtime()
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvimdev/dashboard-nvim",
  "https://github.com/rktjmp/hotpot.nvim",
  "https://github.com/udayvir-singh/hibiscus.nvim",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master"
  },
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
  "https://github.com/nvim-treesitter/playground",
  "https://github.com/augmentcode/augment.vim"
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  sync_install = false,
  auto_install = false,
  -- ignore_install = { "javascript" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>ma"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>mA"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
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

require("hotpot").setup({
  provide_require_fennel = true,
  enable_hotpot_diagnostics = true
})

require("custom-dashboard")
require("options")
require("mappings")
require("lsp")
require("plugins")
require("user_commands")
require("autocommands")

vim.cmd[[
inoremap <M-l> <cmd>call augment#Accept()<cr>
inoremap <cr> <cmd>call augment#Accept("\n")<cr>
nnoremap <leader>ac :Augment chat<CR>
vnoremap <leader>ac :Augment chat<CR>
nnoremap <leader>an :Augment chat-new<CR>
nnoremap <leader>at :Augment chat-toggle<CR>
]]
