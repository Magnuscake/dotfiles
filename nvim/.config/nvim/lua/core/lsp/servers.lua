local custom_attach = require("core.lsp.custom_attach")

local servers = {}

-- servers.sumneko_lua = {
--   flags = { debounce_text_changes = 150 },
--
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = "LuaJIT",
--         -- Setup your lua path
--         path = vim.split(package.path, ";"),
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = { "vim" },
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = {
--           [vim.fn.expand("$VIMRUNTIME/lua")] = true,
--           [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
--         },
--       },
--       telemetry = { enable = false },
--     },
--   },
-- }

servers.tsserver = {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
    local ts_utils = require("nvim-lsp-ts-utils")

    -- defaults
    ts_utils.setup {
      debug = false,
      disable_commands = false,
      enable_import_on_completion = true,

      -- eslint
      eslint_enable_code_actions = true,
      eslint_enable_disable_comments = true,
      eslint_bin = "eslint_d",
      eslint_config_fallback = nil,
      eslint_enable_diagnostics = true,

      -- formatting
      enable_formatting = true,
      formatter = "prettierd",
      formatter_config_fallback = nil,

      -- parentheses completion
      complete_parens = false,
      signature_help_in_parens = false,

      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
    }

    -- required to fix code action ranges
    ts_utils.setup_client(client)

    custom_attach(client, bufnr)
  end,
}

servers.bashls = {
  -- on_attach = function(client, bufnr)
  --   custom_attach(client, bufnr)
  -- end,
}

servers.vimls = {
  -- on_attach = function(client, bufnr)
  --   custom_attach(client, bufnr)
  -- end,
}

-- vscode-css-language-server
servers.cssls = {
  flags = { debounce_text_changes = 150 },
}

-- vscode-html-language-server
servers.html = {
  flags = { debounce_text_changes = 150 },
}

-- JSON
-- vscode-json-language-server
servers.jsonls = {
  flags = { debounce_text_changes = 150 },
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
          },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json",
          },
          url = "http://json.schemastore.org/stylelintrc.json",
        },
      },
    },
  },
}

-- PYTHON
servers.pyright = {}

-- GOPLS
servers.gopls = {
  -- on_attach = function(client, bufnr)
  --   client.server_capabilities.document_formatting = false
  --   custom_attach(client, bufnr)
  -- end,
  flags = { debounce_text_changes = 150 },
}

-- HASKELL
servers.hls = {
  -- on_attach = function(client, bufnr)
  --   client.server_capabilities.document_formatting = false
  --   custom_attach(client, bufnr)
  -- end,
}

servers.svelte = {
  -- on_attach = function(client, bufnr)
  --   client.server_capabilities.document_formatting = false
  --   custom_attach(client, bufnr)
  -- end,
}

-- TAILWINDCSS
servers.tailwindcss = {
  -- on_attach = function(client, bufnr)
  --   custom_attach(client, bufnr)
  -- end,
}

return servers
