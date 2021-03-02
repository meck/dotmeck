-- {{{ Misc
-- vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=1 :

local g = vim.g     -- Global Variables
local b = vim.b     -- Window Variables
local w = vim.w     -- Buffer Variables

local o = vim.o     -- Global Options
local bo = vim.bo   -- Buffer Options
local wo = vim.wo   -- Window Options

-- Mapings, :h nvim_set_keymap
local map = vim.api.nvim_set_keymap
local mapb_b = vim.api.nvim_buf_set_keymap

---------------------------------------------------------------------}}}
--                              Plugin                               {{{
------------------------------------------------------------------------


-- Lualine
local lualine = require('lualine')
local lsp_status = require'lsp_statusline'.status_string
local lsp_curr_fn = require'lsp_statusline'.curr_fn
local obsession_status = function ()
  return vim.fn['ObsessionStatus']('Ⓢ', '')
end

lualine.status{
  options = {
    theme = 'nord',
    section_separators = {'', ''},
    component_separators = {nil, nil},
    icons_enabled = true,
  },
  sections = {
    lualine_b = { 'branch', 'diff' },
    lualine_c = { obsession_status, 'filename' },
    lualine_x = { 'fileformat', 'filetype' },
    lualine_y = {
        lsp_curr_fn,
        {'diagnostics', sources = {'nvim_lsp'} },
        lsp_status
      },
    lualine_z = { 'progress', 'location' },
  },
  inactive_sections = {
    lualine_c = { obsession_status, 'filename' },
  },
}


-- Telescope
local telescope = require'telescope'

telescope.setup{
  defaults = {
    mappings = {
      i = {
        -- Close with only one `esc`
        ["<esc>"] = require'telescope.actions'.close
      },
    },
  }
}

-- View avalible lists
map('n','<Leader>c', [[<cmd>lua require'telescope.builtin'.builtin{}<CR>]],
  { noremap = true, silent = true })
-- Search for files
map('n','<Leader>f', [[<cmd>lua require'telescope.builtin'.find_files{}<CR>]],
  { noremap = true, silent = true })
map('n','<Leader>F', [[<cmd>lua require'telescope.builtin'.git_files{}<CR>]],
  { noremap = true, silent = true })
-- Search buffers
map('n','<Leader>b', [[<cmd>lua require'telescope.builtin'.buffers{}<CR>]],
  { noremap = true, silent = true })
-- Grep
map('n','<Leader>g', [[<cmd>lua require'telescope.builtin'.live_grep{}<CR>]],
  { noremap = true, silent = true })



-- Treesitter
if vim.fn.executable("gcc")   == 1 or
   vim.fn.executable("clang") == 1 then
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained",

    highlight = {
      enable = true
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = "gnn",
        -- node_incremental = "grn",
        -- scope_incremental = "grc",
        -- node_decremental = "grm",
      }
    },

    indent = {
      enable = true
    }
  }
else
 vim.notify("Treesitter disabled", vim.log.levels.INFO)
end
