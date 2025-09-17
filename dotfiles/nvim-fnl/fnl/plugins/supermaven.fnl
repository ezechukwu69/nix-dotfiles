(vim.pack.add ["https://github.com/supermaven-inc/supermaven-nvim" ])

(local supermaven (require :supermaven-nvim))

(supermaven.setup {
                  :keymaps {
                    :accept_suggestion "<M-l>"
                    :clear_suggestion "<C-p>"
                    :accept_word "<C-]>"
                  }
                  :color {
                    :suggestion_color "#614500"
                    :cterm 204
                  }
})
