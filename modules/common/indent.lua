function indent_cpp()
  -- written by JB Mouret -- mouret@isir.upmc.fr
  local buffer = buffer
  -- unindent the current line (to make empty lines empty)
  local line = buffer.line_from_position(buffer.current_pos)
  local indent = buffer.line_indentation[line];
  local start_pos = buffer.line_end_position[line - 1] + 1
  local s = math.max(start_pos, buffer.current_pos - indent)
  for i=1,10 do buffer.back_tab() end
  local line_length = buffer.line_length(line)
  local empty_line = (line_length == 1)
  if (empty_line) then buffer.add_text(';') end
  local input = buffer:get_text()
  local tmpfile = _USERHOME..'/.ft'
  local conf = _USERHOME..'/crust.cfg'
  local f = io.open(tmpfile, 'wb')
  f:write(input)
  f:close()
  local cmd = table.concat({"uncrustify -q -c ", conf, ' -f "'..tmpfile..'"'}, ' ')
  local p = io.popen(cmd)
  local fv2 = buffer.first_visible_line
  buffer:set_text(p:read('*all'))
  buffer:line_scroll(0, fv2);
  s = s + buffer.line_indentation[buffer.line_from_position(s)]
  buffer:goto_pos(s)
  if (empty_line) then
    buffer:line_end()
    buffer:delete_back();
  end
  os.remove(tmpfile)
end
To bind this function to "tab" (as emacs does it):

_G.keys.cpp['\t'] = indent_cpp


-- ESC i
-- filter_through(cmd)
