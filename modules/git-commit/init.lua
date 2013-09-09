local M = {}
local c = _SCINTILLA.constants

-- Configure default line edge to be at 50 characters (short description).
events.connect(events.LANGUAGE_MODULE_LOADED, function(lang)
  local buffer = buffer
  if lang == 'git-commit' then
    buffer.edge_mode = c.EDGE_LINE
    buffer.edge_colour = '0xFF7777'
    buffer.edge_column = 50
  end
end)

-- Put the line edge at 50 characters if on short description (1st) line,
-- otherwise, put the line edge at 72 characters for extended description.
events.connect(events.UPDATE_UI, function()
  local buffer = buffer
  local lang = buffer:get_lexer()
  if lang == 'git-commit' then
    local curLine = buffer:line_from_position(buffer.current_pos)
    if curLine == 0 then
      buffer.edge_column = 50
    else
      buffer.edge_column = 72
    end
  end
end)

return M

