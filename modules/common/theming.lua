
local M = {}

local constants = _SCINTILLA.constants
local TA = _M.textadept
local MARK = TA.bookmarks
  


-- See also the themes'
-- [buffer.lua](http://code.google.com/p/textadept/source/browse/themes/light/buffer.lua)
-- and
-- [view.lua](http://code.google.com/p/textadept/source/browse/themes/light/view.lua)
-- for more options.

function buffer_theming()
  local buffer = buffer

--[=[
  buffer.view_ws = 0
  buffer.virtual_space_options = 1 -- enabled only for rectangular selection
  buffer.edge_column = 80
  buffer.edge_mode = 1
  buffer.wrap_mode = 1
  buffer.multiple_selection = true
  buffer.additional_selection_typing = true
  buffer.additional_carets_visible = true
  buffer.zoom = 2 -- e.g. add 2 points to the font size
]=]
  
  
  -- Set number margin for files with more than 999 lines
  local width = #(buffer.line_count..'')
  width = width > 3 and width or 3
  buffer.margin_width_n[0] = 4 + width * buffer:text_width(constants.STYLE_LINENUMBER, '9')
end



local NCURSES_MARK = constants.SC_MARK_CHARACTER + string.byte(' ')

function bookmark_theming()
  if NCURSES then
    buffer:marker_define(MARK.MARK_BOOKMARK, NCURSES_MARK)
    buffer.marker_back[MARK_BOOKMARK] = M.MARK_BOOKMARK_COLOR
  else
    buffer:marker_define(MARK.MARK_BOOKMARK, constants.SC_MARK_ROUNDRECT)
    buffer.margin_width_n[1] = 16   -- buffer:text_width(constants.STYLE_LINENUMBER, '9')
     
  end
  
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

events.disconnect(events.VIEW_NEW, MARK.EVENT_ID)
MARK.EVENT_ID = events.connect(events.VIEW_NEW, bookmark_theming)


return M
