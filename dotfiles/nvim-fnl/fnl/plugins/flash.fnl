(vim.pack.add ["https://github.com/folke/flash.nvim"])

(local Flash (require "flash"))

(Flash.setup {
             :modes {
                     :search {:enable true}
                     :char {
                             :jump {
                                     :autojump true
                             }
                     }
             }

             :remote_op {
                          :restore true
             }
      })

(vim.keymap.set ["n" "x" "o"] "s" (fn [] (Flash.jump)) {:desc "Flash"})
(vim.keymap.set ["n" "x" "o"] "S" (fn [] (Flash.treesitter)) {:desc "Flash Treesitter"})
(vim.keymap.set ["o"] "r" (fn [] (Flash.remote)) {:desc "Flash Remote"})
(vim.keymap.set ["o" "x"] "R" (fn [] (Flash.treesitter_search)) {:desc "Treesitter Search"})
;; toggle flash search in "o" mode
(vim.keymap.set "o" "<c-s>" (fn [] (Flash.toggle_search)) {:desc "Toggle Flash Search"})

