

local TA = _M.textadept
local COM = _M.common

TA.keys = require 'textadept.keys'


local keys = _G.keys
local b, v = 'buffer', 'view'



keys.ab         = { COM.display_filename.switch_buffer }
--keys.ag         = { COM.ctags.goto_symbol }

keys.av         = { 'split', v } -- vertical
keys.ah         = { 'split', v, false }

keys.aa         = { 'select_all', b }

keys.af         = { gui.find.find_incremental }

keys['a ']      = { TA.bookmarks.toggle }
keys.an         = { TA.bookmarks.goto_next }
keys.ap         = { TA.bookmarks.goto_prev }

keys['a+']      = { expand_fold }
keys['a-']      = { collapse_fold }

keys.ae         = { TA.editing.match_brace }
keys.aE         = { TA.editing.match_brace, 'select' }



--keys.cao        = { COM.filename.insert_filename }
--keys.caf        = { COM.ack.search_entry }


keys.ca         = { 'vc_home', b }
keys.ce         = { 'line_end', b }

keys.cb         = { COM.lastbuffer.last_buffer }

keys.ck         = {
      function()
        buffer:line_end_extend()
        buffer:clear()
      end
    }

keys.cu         = { 'del_line_left', b }



keys['esc']   = {
  ['\b']        = { 'del_word_left', b },
  d             = { 'del_word_right', b },

  b             = { 'word_left', b },
  f             = { 'word_right', b },

  g             = { TA.bookmarks.goto_bookmark },

  r             = { gui.find.replace },

  n             = { gui.goto_view, 1, false },
  p             = { gui.goto_view, -1, false },

  x             = { gui.command_entry.focus },

  w             = { function() view:unsplit() return true end  },

  ['#']         = { TA.editing.block_comment },


} -- keys(esc)

  
TA.menu = require 'textadept.menu'

