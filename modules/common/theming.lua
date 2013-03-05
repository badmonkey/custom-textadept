
local M = {}


-- See also the themes'
-- [buffer.lua](http://code.google.com/p/textadept/source/browse/themes/light/buffer.lua)
-- and
-- [view.lua](http://code.google.com/p/textadept/source/browse/themes/light/view.lua)
-- for more options.

function buffer_theming()
  local buffer = buffer
  local c = _SCINTILLA.constants
  local TA = _M.textadept

--[=[
  buffer.view_ws = 0
  buffer.virtual_space_options = 1 -- enabled only for rectangular selection
  buffer.edge_column = 80
  buffer.edge_mode = 1
  buffer.wrap_mode = 1
  buffer.multiple_selection = true
  buffer.additional_selection_typing = true
  buffer.additional_carets_visible = true
]=]
  
  --buffer.zoom = 2 -- e.g. add 2 points to the font size
  
  -- Set number margin for files with more than 999 lines
  local width = #(buffer.line_count..'')
  width = width > 3 and width or 3
  buffer.margin_width_n[0] = 4 + width * buffer:text_width(c.STYLE_LINENUMBER, '9')
end


function bookmark_theming()
  --buffer:marker_define(TA.bookmarks.MARK_BOOKMARK, _SCINTILLA.constants.SC_MARK_ROUNDRECT)
  --buffer:marker_set_fore(_M.textadept.bookmarks.MARK_BOOKMARK, colour_parse(blue))
  --buffer.margin_width_n[1] = 16
end



-- Connect events.
--events.connect('file_opened', set_buffer_properties)
--events.connect('buffer_new', set_buffer_properties)
--events.connect('view_new', set_buffer_properties)

events.connect(events.BUFFER_AFTER_SWITCH, buffer_theming)
events.connect(events.VIEW_AFTER_SWITCH, buffer_theming)

events.connect(events.RESET_AFTER, function()
  for i=1, #_VIEWS do
    gui.goto_view(1, false)
    view:focus()
    buffer_theming()
  end
end)

events.connect(events.VIEW_NEW, bookmark_theming)


return M
