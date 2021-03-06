-- Shorten display filenames in buffer title and switch buffer dialog.
-- On Windows
--     C:\Documents and Settings\username\Desktop\...
-- is replaced with
--     Desktop\...,
-- on Max OS X and Linux
--     /home/username/..
-- or
--     /Users/username/...
-- with
--     ~/...
--
-- Modified from Textadept's
-- [core.gui](http://code.google.com/p/textadept/source/browse/core/gui.lua) and
-- [snapopen](http://code.google.com/p/textadept/source/browse/modules/textadept/snapopen.lua)
-- module.

local M = {}
local _L = _L

local PROJ = _M.common.project   -- require 'common.project'



-- ## Fields


function M.lookup_name(buffer)
  local filename = buffer.filename or buffer._type or _L['Untitled']
  return PROJ.get_name(filename)
end


-- ## Commands

-- Sets the title of the Textadept window to the buffer's filename.
-- Parameter:<br>
-- _buffer_: The currently focused buffer.
local function set_title(buffer)
  local buffer = buffer
  local dirty = buffer.dirty and '*' or ' '

  local filename = M.lookup_name(buffer)

  ui.title = string.format('Textadept -- %s%s', filename, dirty )

end


-- Disconnect events that use `set_title` from `core/gui.lua`
-- and reconnect with new `set_title` function

events.disconnect(events.SAVE_POINT_REACHED, 1)
events.connect(events.SAVE_POINT_REACHED,
  function() -- changes Textadept title to show 'clean' buffer
    buffer.dirty = false
    set_title(buffer)

  end)

events.disconnect(events.SAVE_POINT_LEFT, 1)
events.connect(events.SAVE_POINT_LEFT,
  function() -- changes Textadept title to show 'dirty' buffer
    buffer.dirty = true
    set_title(buffer)
  end)

events.disconnect(events.BUFFER_AFTER_SWITCH, 3)
events.connect(events.BUFFER_AFTER_SWITCH,
  function() -- updates titlebar and statusbar
    set_title(buffer)
    events.emit('update_ui')
  end)

events.disconnect(events.VIEW_AFTER_SWITCH, 2)
events.connect(events.VIEW_AFTER_SWITCH,
  function() -- updates titlebar and statusbar
    set_title(buffer)
    events.emit('update_ui')
  end, 2)



-- Displays a dialog with a list of buffers to switch to and switches to the
-- selected one, if any.
function M.switch_buffer()
  local items = {}
  for _, buffer in ipairs(_BUFFERS) do
    local dirty = buffer.dirty and '*' or ''
    local filename, shortname, root = M.lookup_name(buffer)

    items[#items + 1] = dirty..shortname
    items[#items + 1] = filename
    --items[#items + 1] = root
  end
  local response = ui.dialog('filteredlist',
                             '--title', _L['Switch Buffers'],
                             '--button1', 'gtk-ok',
                             '--height', 900,
                             '--width', 450,
                             '--button2', 'gtk-cancel',
                             '--no-newline',
                             '--columns', 'Name', 'File',	-- 'Root',
                             '--items', items)
  local ok, i = response:match('(%-?%d+)\n(%d+)$')
  if ok == '1' then view:goto_buffer(tonumber(i) + 1, false) end
end

ui.switch_buffer = M.switch_buffer


return M
