

local TA = _M.textadept
local COM = _M.common
local VIEW = view
local BUFFER = buffer


TA.keys = require 'textadept.keys'

local keys = keys


resize_view = function(v, amt) if v.size then v.size = v.size + amt end end


keys.ab         = { COM.display_filename.switch_buffer }
keys.ag         = { COM.ctags.goto_symbol }
keys.aG         = { COM.ctags.find_project_symbol }

keys.av         = { VIEW.split, VIEW, true } -- vertical
keys.ah         = { VIEW.split, VIEW, false }

keys['a-']      = { resize_view, VIEW, -10 }
keys['a=']      = { resize_view, VIEW,  10 }

keys.aa         = { BUFFER.select_all, BUFFER }

keys.af         = { ui.find.find_incremental }

keys['a ']      = { TA.bookmarks.toggle }
keys.an         = { TA.bookmarks.goto_next }
keys.ap         = { TA.bookmarks.goto_prev }

keys.ae         = { TA.editing.match_brace }
keys.aE         = { TA.editing.match_brace, 'select' }



keys.cao        = { COM.filename.insert_filename }
keys.caf        = { COM.ack.search_entry }


keys.ca         = { BUFFER.vc_home, BUFFER }
keys.ce         = { BUFFER.line_end, BUFFER }

keys.cb         = { COM.lastbuffer.last_buffer }

keys.cg         = { TA.editing.goto_line }

keys.ck         = {
      function()
        BUFFER:line_end_extend()
        BUFFER:clear()
      end
    }

keys.cu         = { BUFFER.del_line_left, BUFFER }



keys['esc']   = {
  ['\b']        = { BUFFER.del_word_left, BUFFER },
  d             = { BUFFER.del_word_right, BUFFER },

  b             = { BUFFER.word_left, BUFFER },
  f             = { BUFFER.word_right, BUFFER },

  g             = { TA.bookmarks.goto_bookmark },

  r             = { ui.find.replace },

  n             = { ui.goto_view, 1, true },
  p             = { ui.goto_view, -1, true },

  x             = { ui.command_entry.focus },

  w             = { function(v) v:unsplit() return true end, VIEW },
  cw            = { function() while view:unsplit() do end end },

  ['/']         = { TA.editing.block_comment },

  i             = { COM.indent.indent_buffer },
  [' ']         = { COM.complete.complete_buffer },

} -- keys(esc)

  
TA.menu = require 'textadept.menu'

