(vim.pack.add [
               {:src "https://github.com/saghen/blink.cmp" :version (vim.version.range "1.*") }
               "https://github.com/rafamadriz/friendly-snippets"
               "https://github.com/Kaiser-Yang/blink-cmp-avante"
               ])

(local blink (require :blink.cmp))

(blink.setup {
             :keymap {
                      :preset :enter
             }

             :sources {
                      :default ["avante" "lsp" "path" "snippets" "buffer" ]
                      :providers {
                              :avante {
                                      :module :blink-cmp-avante
                                      :name "Avante"
                                      :opts {}
                              }
                      }
             }
            
             :appearance {
                      :nerd_font_variant "normal"
             }

             :completion { :documentation {  :auto_show true  }  }
})
