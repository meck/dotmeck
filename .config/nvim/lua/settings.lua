-- vim: set foldmethod=marker foldlevel=1 :
-- {{{ Misc
local g = vim.g -- Global Variables
local b = vim.b -- Window Variables
local w = vim.w -- Buffer Variables

local o = vim.o -- Global Options
local bo = vim.bo -- Buffer Options
local wo = vim.wo -- Window Options

-- Mapings, :h nvim_set_keymap
local map = vim.api.nvim_set_keymap
local mapb = vim.api.nvim_buf_set_keymap

---------------------------------------------------------------------}}}
--                              Plugins                              {{{
------------------------------------------------------------------------

---------------
--  Lualine  --
---------------
do
  local lualine = require('lualine')
  local lsp_status = require'lsp_statusline'.status_string
  local lsp_curr_fn = require'lsp_statusline'.curr_fn

  local obsession_status = function()
    return vim.fn['ObsessionStatus']('Ⓢ', '')
  end

  local lang_status = function()
    local content = {}

    local keymap = bo.keymap
    if keymap ~= '' then
      keymap = 'Key:' .. string.upper(keymap)
      table.insert(content, keymap)
    end

    if wo.spell then
      local spell = ''
      spell = string.gsub(bo.spelllang, ',', '/')
      spell = 'Spell:' .. string.upper(spell)
      table.insert(content, spell)
    end

    local msg = ''
    if next(content) ~= nil then
      msg = '[' .. table.concat(content, ' ') .. ']'
    end
    return msg
  end

  lualine.setup {
    options = {
      theme = 'nord',
      section_separators = {'', ''},
      component_separators = {nil, nil},
      icons_enabled = true
    },
    sections = {
      lualine_a = {'mode', lang_status},
      lualine_b = {'branch', 'diff'},
      lualine_c = {obsession_status, 'filename'},
      lualine_x = {'fileformat', 'filetype', lsp_curr_fn},
      lualine_y = {lsp_status, {'diagnostics', sources = {'nvim_lsp'}}},
      lualine_z = {'progress', 'location'}
    },
    inactive_sections = {

      lualine_b = {'branch', 'diff'},
      lualine_c = {obsession_status, 'filename'}
    }
  }
end

-----------------
--  Telescope  --
-----------------
local telescope = require 'telescope'

telescope.setup {
  defaults = {
    mappings = {
      i = {
        -- Close with only one `esc`
        ["<esc>"] = require'telescope.actions'.close
      }
    }
  }
}

-- View avalible lists
map('n', '<Leader><Leader>',
    [[<cmd>lua require'telescope.builtin'.builtin{}<CR>]],
    {noremap = true, silent = true})
-- Search for files
map('n', '<Leader>f', [[<cmd>lua require'telescope.builtin'.find_files{}<CR>]],
    {noremap = true, silent = true})
-- Search for files
map('n', '<Leader>F', [[<cmd>lua require'telescope.builtin'.git_files{}<CR>]],
    {noremap = true, silent = true})
-- Search buffers
map('n', '<Leader>b', [[<cmd>lua require'telescope.builtin'.buffers{}<CR>]],
    {noremap = true, silent = true})
-- Grep
map('n', '<Leader>g', [[<cmd>lua require'telescope.builtin'.live_grep{}<CR>]],
    {noremap = true, silent = true})

------------------
--  Treesitter  --
------------------
if vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1 then
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",

    highlight = {enable = true},

    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = "gnn",
        -- node_incremental = "grn",
        -- scope_incremental = "grc",
        -- node_decremental = "grm",
      }
    },

    indent = {enable = true}
  }
else
  vim.notify("Treesitter disabled", vim.log.levels.INFO)
end

------------------
--  nvim-compe  --
------------------
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'always',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    tags = true,
    treesitter = true,
    ultisnips = true,
    vsnip = false,
    snippets_nvim = false
  }
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
  -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
  --   return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
  --   return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

-- Mappings

-- These are handled by compe
g.UltiSnipsExpandTrigger = "<Nop>"
g.UltiSnipsListSnippets = "<Nop>"

map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

map("i", "<C-Space>", "compe#complete()", {expr = true, silent = true})
map("i", "<CR>", "compe#confirm('<CR>')", {expr = true, silent = true})
map("i", "<C-e>", "compe#close('<C-e>')", {expr = true, silent = true})
-- map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {expr = true, silent = true})
-- map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", {expr = true, silent = true})

