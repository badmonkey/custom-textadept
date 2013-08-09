-- Toggle between two buffers with a key shortcut.

local M = {}


M.last_buffer_index = 0

-- ## Commands

-- Save the buffer index before switching.
events.connect('buffer_before_switch',
  function()
    M.last_buffer_index = _BUFFERS[buffer]
  end)

  
-- Switch to last buffer.
function M.last_buffer()
  if M.last_buffer_index and #_BUFFERS >= M.last_buffer_index then
    view:goto_buffer(M.last_buffer_index, false)
  end
end


return M
