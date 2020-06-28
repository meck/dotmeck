local vim = vim
local diagnostics = require('lsp-status/diagnostics')
local messages = require('lsp-status/messaging').messages

local aliases = { pyls_ms = 'MPLS' }
local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

local M = {}

M.curr_fn = function ()
  local f = vim.b.lsp_current_function
  if f and f ~= '' then
    return f
  else
    return ''
  end
end

M.errors = function()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local buf_diagnostics = diagnostics()
  if buf_diagnostics.errors and buf_diagnostics.errors > 0 then
    return buf_diagnostics.errors
  end
  return ''
end

M.warnings = function()
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local buf_diagnostics = diagnostics()
  local status_parts = {}

  if buf_diagnostics.warnings and buf_diagnostics.warnings > 0 then
    table.insert(status_parts,  buf_diagnostics.warnings .. '⚠ ')
  end

  if buf_diagnostics.info and buf_diagnostics.info > 0 then
    table.insert(status_parts,  buf_diagnostics.info .. 'ℹ')
  end

  if buf_diagnostics.hints and buf_diagnostics.hints > 0 then
    table.insert(status_parts,  buf_diagnostics.hints ..'◉')
  end

  return vim.trim(table.concat(status_parts, ' '))

end

M.status_string =  function()

  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local buf_messages = messages()

  local msgs = {}
  for _, msg in ipairs(buf_messages) do
    local name = aliases[msg.name] or msg.name
    local client_name = '[' .. name .. ']'
    local contents = ''
    if msg.progress then

      contents = msg.title

      if msg.message then
        contents = contents .. ' ' .. msg.message
      end

      if msg.percentage then
        contents = contents .. ' (' .. msg.percentage .. ')'
      end

      if msg.spinner then
        contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' .. contents
      end

    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = '(' .. filename .. ') ' .. contents
      end

    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)

  end

  local status_line =  table.concat(msgs, ' ')

  if status_line ~= '' then
    return status_line
  end
  return '✓'
end

return M
