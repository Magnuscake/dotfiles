local M = {}

function M.config()
  vim.lsp.protocol.CompletionItemKind = {
    'ﮜ [text]',
    ' [method]',
    ' [function]',
    ' [constructor]',
    'ﰠ [field]',
    ' [variable]',
    ' [class]',
    ' [interface]',
    ' [module]',
    ' [property]',
    ' [unit]',
    ' [value]',
    ' [enum]',
    ' [key]',
    ' [snippet]',
    ' [color]',
    ' [file]',
    ' [reference]',
    ' [folder]',
    ' [enum member]',
    ' [constant]',
    ' [struct]',
    '⌘ [event]',
    ' [operator]',
    '⌂ [type]',
  }

  vim.o.completeopt = "menuone,noselect"

  require 'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
      path = true;
      buffer = true;
      calc = true;
      nvim_lsp = true;
      nvim_lua = true;
    };
  }

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
      return true
    else
      return false
    end
  end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
  --- jump to prev/next snippet's placeholder
  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-n>"
--[[ elseif vim.fn.call("vsnip#available", {1}) == 1 then
      return t "<Plug>(vsnip-expand-or-jump)" ]]
    elseif check_back_space() then
      return t "<Tab>"
    else
      return vim.fn['compe#complete']()
    end
  end
  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
--[[ elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
      return t "<Plug>(vsnip-jump-prev)" ]]
    else
      return t "<S-Tab>"
    end
  end

  _G.enter_complete = function()
    if luasnip and luasnip.choice_active() then
      return t '<Plug>luasnip-next-choice'
    end
    return vim.fn['compe#confirm'](t '<CR>')
  end

  local U = require 'utils'
  local opts = { expr = true, silent = true }
  U.map("i", "<Tab>", "v:lua.tab_complete()", opts)
  U.map("s", "<Tab>", "v:lua.tab_complete()", opts)
  U.map("i", "<S-Tab>", "v:lua.s_tab_complete()", opts)
  U.map("s", "<S-Tab>", "v:lua.s_tab_complete()", opts)
  U.map('i', '<CR>', 'v:lua.enter_complete()', opts)
end

return M
