

local TA = _M.textadept
local COM = _M.common
local VIEW = view
local BUFFER = buffer


TA.keys = require 'textadept.keys'

local keys = keys



keys.ab         = { COM.display_filename.switch_buffer }
keys.ag         = { COM.ctags.goto_symbol }
keys.aG         = { COM.ctags.find_project_symbol }

keys.av         = { VIEW.split, VIEW, true } -- vertical
keys.ah         = { VIEW.split, VIEW, false }

keys.aa         = { BUFFER.select_all, BUFFER }

keys.af         = { gui.find.find_incremental }

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

  r             = { gui.find.replace },

  n             = { gui.goto_view, 1, true },
  p             = { gui.goto_view, -1, true },

  x             = { gui.command_entry.focus },

  w             = { function() VIEW:unsplit() return true end  },

  ['/']         = { TA.editing.block_comment },

  i             = { COM.indent.indent_buffer },
  [' ']         = { COM.complete.complete_buffer },

} -- keys(esc)

  
TA.menu = require 'textadept.menu'

