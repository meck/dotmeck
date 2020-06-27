-- TODO show hover as info in completion HIE
-- TODO status airline

local nvim_lsp = require'nvim_lsp'
local lsp_status = require'lsp-status'
local configs = require'nvim_lsp/configs'

local vim = vim
local api = vim.api
local lsp = vim.lsp

local set_mappings = function(bufnr)

  local opts = { noremap=true, silent=true }


  -- `diagnostics.vim` mappings
  api.nvim_buf_set_keymap(bufnr, 'n', '[s', '<cmd>lua require"jumpLoc".jumpPrevLocationCycle()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', ']s', '<cmd>lua require"jumpLoc".jumpNextLocationCycle()<CR>', opts)
  api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ld', '<cmd>lua require"jumpLoc".openDiagnostics()<CR>', opts)


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
  lsp_status.on_attach(client, bufnr)
  lsp_status.register_progress()

  -- Diagnostics
  require'diagnostic'.on_attach()

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


api.nvim_command("command! Test lua require'lsp_statusline'.status()")

if not Lsp_signs_defined then
  vim.fn.sign_define('LspDiagnosticsErrorSign', {text='✖', texthl='LspDiagnosticsError', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsWarningSign', {text='⚠', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsInformationSign', {text='ℹ', texthl='LspDiagnosticsInfo', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsHintSign', {text='◉', texthl='LspDiagnosticsHint', linehl='', numhl=''})
  Lsp_signs_defined = true
end



---------------
--  Servers  --
---------------

-- HLS
if not configs.hls then
  configs.hls = {
    default_config = {
      cmd = {"haskell-language-server", "--lsp"};
      filetypes = {"haskell"};
      root_dir = require'nvim_lsp/util'.root_pattern("stack.yaml", "package.yaml", ".git");
      settings = {};
    };
  }
end

if vim.fn.executable("haskell-language-server") == 1 then
  nvim_lsp.hls.setup{
    on_attach = attach_fn;
    init_options = {
      languageServerHaskell = {
        hlintOn = true;
        completionSnippetsOn = true;
        formatOnImportOn = true;
     }
    }
  };
end



-- HIE
if vim.fn.executable("hie") == 1 then
  nvim_lsp.hie.setup{
    cmd = {"hie", "--lsp"};
    filetypes = { "haskell" ,  "lhs" , "hs" };
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
    init_options = {
      languageServerHaskell = {
        hlintOn = true;
        completionSnippetsOn = true;
        formatOnImportOn = true;
        formattingProvider = 'brittany';
      }
    }
  }
end



-- clangd
if vim.fn.executable("clangd") == 1 then
  nvim_lsp.clangd.setup{
    cmd = { "clangd", "--background-index" };
    filetypes = { "c", "cpp", "objc", "objcpp" };
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
  }
end



-- Nix
if vim.fn.executable("rnix-lsp") == 1 then
  nvim_lsp.rnix.setup{
    cmd = { "rnix-lsp" };
    filetypes = { "nix" };
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
  }
end


-- Lua
if vim.fn.executable("lua-langauge-server") == 1 then
  nvim_lsp.sumneko_lua.setup{
    cmd = { "lua-language-server" };
    on_attach = attach_fn;
    capabilities = lsp_status.capabilities;
  }
end
