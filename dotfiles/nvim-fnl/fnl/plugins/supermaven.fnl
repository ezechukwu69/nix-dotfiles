(vim.pack.add ["https://github.com/supermaven-inc/supermaven-nvim" ])

(local supermaven (require :supermaven))

(supermaven.setup {
                  :keymaps {
                    :accept_suggestions "<M-l>"
                    :clear_suggestion "<C-p>"
                    :accept_word "<C-]>"
                  }
                  :color {
                    :suggestion_color "#614500"
                  }
})
