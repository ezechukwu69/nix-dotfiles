vim.pack.add({ "https://github.com/akinsho/bufferline.nvim" })

require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    indicator = {
      style = "underline",
    },
  },
})
