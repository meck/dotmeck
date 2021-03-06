local lspconfig = require 'lspconfig'
local lsp_status = require 'lsp-status'
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local vim = vim
local api = vim.api
local lsp = vim.lsp

Formatexpr_wrapper = function()

  -- only reformat on explicit gq command
  if not vim.fn.mode() == 'n' then
    -- fall back to Vims internal reformatting
    return 1
  end

  local opts = {}
  local start_line = vim.v.lnum
  local end_line = start_line + vim.v.count - 1
  if start_line >= 0 and end_line >= 0 then
    lsp.buf.range_formatting(opts, {start_line, 0}, {end_line, 0})
  end

  return 0
end

-- Called when a server starts
local attach_fn = function(client, bufnr)

  local map_b = api.nvim_buf_set_keymap
  local opts = {noremap = true, silent = true}

  -- Statusbar
  lsp_status.on_attach(client)
  lsp_status.register_progress()

  -- Turn on signcolumn for the current window
  api.nvim_win_set_option(0, 'signcolumn', 'yes')

  -- Highlight item under the cursor
  if client.resolved_capabilities['document_highlight'] then
    api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  end

  -- `nvim-lightbulb` and mapping "leader a"
  if client.resolved_capabilities.code_action then
    vim.cmd [[autocmd CursorHold,CursorHoldI <buffer> lua require'nvim-lightbulb'.update_lightbulb()]]
    map_b(bufnr, 'n', '<leader>a',
          '<cmd>lua require\'telescope.builtin\'.lsp_code_actions()<CR>', opts)
    map_b(bufnr, 'v', '<leader>a',
          '<cmd>lua require\'telescope.builtin\'.lsp_range_code_actions()<CR>',
          opts)
  end

  -- `diagnostics.vim` mappings
  map_b(bufnr, 'n', '[s', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  map_b(bufnr, 'n', ']s', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  map_b(bufnr, 'n', '<leader>ld',
        '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Builtin lsp mappings
  map_b(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map_b(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map_b(bufnr, 'n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map_b(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map_b(bufnr, 'n', 'gr',
        '<cmd>lua require\'telescope.builtin\'.lsp_references()<CR>', opts)
  map_b(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map_b(bufnr, 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map_b(bufnr, 'n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  map_b(bufnr, 'n', '<leader>e',
        '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  map_b(bufnr, 'n', '<leader>ls',
        '<cmd>lua require\'telescope.builtin\'.lsp_document_symbols()<CR>', opts)
  map_b(bufnr, 'n', '<leader>lS',
        '<cmd>lua require\'telescope.builtin\'.lsp_workspace_symbols()<CR>',
        opts)

  -- Explicit LSP formatting
  if client.resolved_capabilities.document_formatting then
    map_b(bufnr, "n", "<leader>gq", "<cmd>lua vim.lsp.buf.formatting()<CR>",
          opts)
  end

  -- Use `gq` for range formating
  -- https://github.com/neovim/neovim/issues/12528
  if client.resolved_capabilities.document_range_formatting then
    api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.Formatexpr_wrapper()')
  end

end

-- Disable virual text
lsp.handlers["textDocument/publishDiagnostics"] =
    lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = false,
      signs = true,
      update_in_insert = false
    })
-- Signs and their highlights
if not Lsp_signs_defined then
  vim.fn.sign_define('LspDiagnosticsSignError', {
    text = '',
    texthl = 'LspDiagnosticsDefaultError',
    linehl = '',
    numhl = ''
  })
  vim.fn.sign_define('LspDiagnosticsSignWarning', {
    text = '',
    texthl = 'LspDiagnosticsDefaultWarning',
    linehl = '',
    numhl = ''
  })
  vim.fn.sign_define('LspDiagnosticsSignInformation', {
    text = '',
    texthl = 'LspDiagnosticsDefaultInfo',
    linehl = '',
    numhl = ''
  })
  vim.fn.sign_define('LspDiagnosticsSignHint', {
    text = '◉',
    texthl = 'LspDiagnosticsDefaultHint',
    linehl = '',
    numhl = ''
  })
  vim.fn.sign_define('LightBulbSign', {
    text = "⚑",
    texthl = "Number",
    linehl = '',
    numhl = ''
  }) -- nvim-lightbulb
  Lsp_signs_defined = true
end

-- default for all servers
lspconfig.util.default_config = vim.tbl_extend("force",
                                               lspconfig.util.default_config, {
  on_attach = attach_fn,
  capabilities = lsp_status.capabilities
})

---------------
--  Servers  --
---------------

-- EFM Langserver
local efm_lang = require 'efm'
local efm_filetypes = {}
for k, _ in pairs(efm_lang) do efm_filetypes[#efm_filetypes + 1] = k end

lspconfig.efm.setup({
  -- Git or local location
  root_dir = function(fname)
    return util.find_git_ancestor(fname) or util.path.dirname(fname)
  end,
  -- cmd = {'efm-langserver', "-logfile", "/tmp/efm.log", "-loglevel", "10"},
  init_options = {documentFormatting = true},
  filetypes = efm_filetypes,
  settings = {rootMarkers = {'.git/'}, languages = efm_lang}
})

-- Clangd
lspconfig.clangd.setup {
  cmd = {vim.fn.exepath('clangd'), '--clang-tidy', '--suggest-missing-includes'},
  filetypes = {"c", "cpp", "objc", "objcpp"},
  init_options = {clangdFileStatus = true}
}

-- HLS
lspconfig.hls.setup {
  init_options = {
    languageServerHaskell = {
      hlintOn = true,
      completionSnippetsOn = true,
      formatOnImportOn = true
    }
  }
}

-- Nix
lspconfig.rnix.setup {cmd = {"rnix-lsp"}, filetypes = {"nix"}}

-- Rust
lspconfig.rust_analyzer.setup {}

-- vhdl-tool
if not configs.vhdl_tool then
  configs.vhdl_tool = {
    default_config = {
      cmd = {'vhdl-tool', 'lsp'},
      filetypes = {'vhdl'},
      root_dir = lspconfig.util.root_pattern("vhdltool-config.yaml"),
      settings = {}
    }
  }
end
lspconfig.vhdl_tool.setup {}

-- Pyright
lspconfig.pyright.setup {}

-- Lua
lspconfig.sumneko_lua.setup {
  cmd = {"lua-language-server"},
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        -- Get the language server to recognize the `vim` global
        globals = {'vim'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      }
    }
  }
}

-- yaml
lspconfig.yamlls.setup {}

-- bash
lspconfig.bashls.setup {}

