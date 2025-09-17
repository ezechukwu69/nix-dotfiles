(vim.pack.add ["https://github.com/stevearc/quicker.nvim" ])

(local quicker (require :quicker))

(quicker.setup {
:keys  [
     { 1 ">" 
       2 "<cmd>lua require('quicker').expand()<CR>" 
       :desc "Expand quickfix content"
     }
     { 1 "<" 
       2 "<cmd>lua require('quicker').collapse()<CR>" 
       :desc "Collapse quickfix content"
     }
  ]
})
