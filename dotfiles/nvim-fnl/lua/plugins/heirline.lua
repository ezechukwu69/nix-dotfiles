vim.pack.add({
  "https://github.com/rebelot/heirline.nvim",
  "https://github.com/Zeioth/heirline-components.nvim",
  "https://github.com/kyazdani42/nvim-web-devicons",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/stevearc/aerial.nvim",
})

local function get_listed_buffers()
  local buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      table.insert(buffers, buf)
    end
  end
  return buffers
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    if #get_listed_buffers() > 1 then
      vim.o.showtabline = 2
    else
      vim.o.showtabline = 0
    end
  end,
  group = vim.api.nvim_create_augroup("HeirlineUpdateTabLine", { clear = true }),
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("Heirline", { clear = true }),
  callback = function()
    require 'nvim-web-devicons'.setup {}
    require("aerial").setup({
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
        "Variable",
        "Property",
        "Object",
        "Package",
        "Namespace",
        "Constant",
        "Array",
        "Boolean",
      },
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
    })
    local heirline = require "heirline"
    local components = require "heirline-components.all"
    components.init.subscribe_to_events()
    heirline.load_colors(components.hl.get_colors())
    require('gitsigns').setup {}

    local no_separator = {
      surround = {
        separator = "none",
      }
    }

    local left_separator = {
      ruler = false,
      percentage = false,
      surround = {
        separator = "left",
      }
    }

    local right_separator = {
      surround = {
        separator = "right",
      }
    }

    local center_separator = {
      surround = {
        separator = "center",
      }
    }

    heirline.setup({
      opts = {
        disable_winbar_cb = function(args) -- We do this to avoid showing it on the greeter.
          local is_disabled = not require("heirline-components.buffer").is_valid(args.buf) or
              components.condition.buffer_matches({
                buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
              }, args.buf)
          return is_disabled
        end,
      },
      statusline = {
        hl = { fg = "white", bg = "black" },
        components.component.mode(),
        components.component.treesitter(no_separator),
        components.component.file_info(),
        components.component.fill(),
        components.component.lsp(),
        components.component.diagnostics(right_separator),
        components.component.fill(),
        components.component.git_diff(),
        components.component.git_branch(no_separator),
        components.component.cmd_info(center_separator),
        components.component.nav(left_separator),
        components.component.mode(no_separator),
      },
      winbar = {
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        fallthrough = false,
        {
          components.component.winbar_when_inactive(),
          components.component.breadcrumbs(),
        }
      },
      tabline = {
        components.component.tabline_conditional_padding(),
        components.component.tabline_buffers(),
        components.component.fill { hl = { bg = "tabline_bg" } },
        components.component.tabline_tabpages(),
      },
      statuscolumn = {
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        components.component.foldcolumn({ hl = { bg = "black" } }),
        components.component.fill(),
        components.component.numbercolumn(),
        components.component.signcolumn(),
      },
    })
    vim.o.foldcolumn = "auto"
    vim.o.showtabline = 0
    vim.o.numberwidth = 4
  end
})
