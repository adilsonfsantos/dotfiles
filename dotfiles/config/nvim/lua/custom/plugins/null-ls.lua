return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()

    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        --null_ls.builtins.diagnostics.cspell,
        --null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.formatting.markdownlint,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.formatting.stylelint,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.completion.luasnip
      },
    })
  end,
}
