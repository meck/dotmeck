local lspconfig = require'lspconfig'
local lsp_status = require'lsp-status'
local configs = require'lspconfig/configs'

local vim = vim
local api = vim.api
local lsp = vim.lsp

local set_mappings = function(bufnr)

  local opts = { noremap=true, silent=true }


  -- `diagnostics.vim` mappings
  api.nvim_buf_set_keymap(bufnr, 'n', '[s', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', ']s', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ld', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)


  -- Builtin lsp mappings
  api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>a',  '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>r',  '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e',  '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lS', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

end


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

  -- Statusbar
  lsp_status.on_attach(client)
  lsp_status.register_progress()

  -- Use plugin instead:
  -- api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Turn on signcolumn for the current window
  api.nvim_win_set_option(0, 'signcolumn', 'yes')


  -- Use `gq` for formating
  if client.resolved_capabilities['document_range_formatting'] then
    -- https://github.com/neovim/neovim/issues/12528
    -- api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.buf.range_formatting()')
    api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.Formatexpr_wrapper()')
  end


  -- Highlight item under the cursor
  if client.resolved_capabilities['document_highlight'] then
    api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  end

  set_mappings(bufnr)
end



Lsp_stop_all = function()
  local clients = lsp.get_active_clients()

  if #clients > 0 then

    lsp.stop_client(clients)
    for _, v in pairs(clients) do
      print("Stopped LSP client " .. v.name)
    end

  else

    print("No LSP clients are running")

  end
end


-- `:LspStopAll` and `:LspRestartAll`
api.nvim_command("command! LspStopAll call v:lua.Lsp_stop_all()")
api.nvim_command("command! -bar LspRestartAll call v:lua.Lsp_stop_all() <bar> edit")


-- Disable virual text
lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
 lsp.diagnostic.on_publish_diagnostics, {
   virtual_text = false,
 }
)

-- Signs and their highlights
if not Lsp_signs_defined then
  vim.fn.sign_define('LspDiagnosticsSignError', {text='✖', texthl='LspDiagnosticsDefaultError', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsSignWarning', {text='⚠', texthl='LspDiagnosticsDefaultWarning', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsSignInformation', {text='ℹ', texthl='LspDiagnosticsDefaultInfo', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsSignHint', {text='◉', texthl='LspDiagnosticsDefaultHint', linehl='', numhl=''})
  Lsp_signs_defined = true
end



---------------
--  Servers  --
---------------

-- vhdl-tool
if not configs.vhdl_tool then
 configs.vhdl_tool = {
    default_config = {
      cmd = {'vhdl-tool', 'lsp'};
      filetypes = {'vhdl'};
      root_dir = require'lspconfig/util'.root_pattern("vhdltool-config.yaml");
      settings = {};
    };
  }
end

if vim.fn.executable("vhdl-tool") == 1 then
  lspconfig.vhdl_tool.setup{
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
  }
end



-- HLS
if vim.fn.executable("haskell-language-server-wrapper") == 1 then
  lspconfig.hls.setup{
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
    init_options = {
      languageServerHaskell = {
        hlintOn = true;
        completionSnippetsOn = true;
        formatOnImportOn = true;
     }
    }
  };
end


-- clangd
if vim.fn.executable("clangd") == 1 then
  lspconfig.clangd.setup{
    cmd = { vim.fn.exepath('clangd'), '--clang-tidy', '--suggest-missing-includes' };
    filetypes = { "c", "cpp", "objc", "objcpp" };
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
    init_options = { clangdFileStatus = true }
  }
end


-- Nix
if vim.fn.executable("rnix-lsp") == 1 then
  lspconfig.rnix.setup{
    cmd = { "rnix-lsp" };
    filetypes = { "nix" };
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
  }
end


-- Lua
if vim.fn.executable("lua-lsp") == 1 then
  lspconfig.sumneko_lua.setup{
    cmd = { "lua-lsp" };
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
  }
end
