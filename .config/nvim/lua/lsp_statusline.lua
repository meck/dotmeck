local messages = require('lsp-status/messaging').messages

local aliases = {pyls_ms = 'MPLS'}
local spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}
local circle_numbers = {
  '❶', '❷', '❸', '❹', '❺', '❻', '❼', '❽', '❾', '❿'
}

local M = {}

M.curr_fn = function()
  local f = vim.b.lsp_current_function
  if not f then
    f = ''
  end
  return f
end

M.status_string = function()

  local n_clients = #vim.lsp.buf_get_clients()
  if n_clients < 1 then return '' end

  local buf_messages = messages()

  local msgs = {}
  for _, msg in ipairs(buf_messages) do
    local name = aliases[msg.name] or msg.name
    local client_name = '[' .. name .. ']'
    local contents = ''
    if msg.progress then

      contents = msg.title

      if msg.message then contents = contents .. ' ' .. msg.message end

      if msg.percentage then
        contents = contents .. ' (' .. msg.percentage .. ')'
      end

      if msg.spinner then
        contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' ..
                       contents
      end

    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then filename = vim.fn.pathshorten(filename) end

        contents = '(' .. filename .. ') ' .. contents
      end

    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)

  end

  local status_line = table.concat(msgs, ' ')

  if status_line ~= '' then return status_line end
  return circle_numbers[n_clients]

end

return M
