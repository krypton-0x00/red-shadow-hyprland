require("nvchad.configs.lspconfig").defaults()

-- LSP servers
local servers = {
  "html",
  "cssls",
  "clangd",          -- C & C++
  "rust_analyzer",
}

vim.lsp.enable(servers)

-- Auto-format on save (Rust + C + C++)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rs", "*.c", "*.cpp", "*.h", "*.hpp" },
  callback = function()
    vim.lsp.buf.format({
      async = false,
      filter = function(client)
        return client.name == "rust_analyzer"
            or client.name == "clangd"
      end,
    })
  end,
})

