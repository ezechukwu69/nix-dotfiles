(vim.pack.add [
               "https://github.com/SmiteshP/nvim-navic"
               "https://github.com/LunarVim/breadcrumbs.nvim"
               ])

(local nvim-navic (require :nvim-navic))
(local breadcrumbs (require :breadcrumbs))

(nvim-navic.setup {
                  :lsp {
                     :auto_attach true
                  }
})

(breadcrumbs.setup {})
