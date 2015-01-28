

resize_view = function(v, amt) if v.size then v.size = v.size + amt end end


--keys.ab         = { COM.display_filename.switch_buffer }
--keys.ag         = { COM.ctags.goto_symbol }
--keys.aG         = { COM.ctags.find_project_symbol }

keys.av         = { view.split, view, true } -- vertical
keys.ah         = { view.split, view, false }

keys['a-']      = { resize_view, view, -10 }
keys['a=']      = { resize_view, view,  10 }

keys.aa         = { buffer.select_all, buffer }

keys.af         = { ui.find.find_incremental }

keys['a ']      = { textadept.bookmarks.toggle }
keys.an         = { textadept.bookmarks.goto_next }
keys.ap         = { textadept.bookmarks.goto_prev }

keys.ae         = { textadept.editing.match_brace }
keys.aE         = { textadept.editing.match_brace, 'select' }



--keys.cao        = { COM.filename.insert_filename }
--keys.caf        = { COM.ack.search_entry }


keys.ca         = { buffer.vc_home, buffer }
keys.ce         = { buffer.line_end, buffer }

--keys.cb         = { COM.lastbuffer.last_buffer }

keys.cg         = { textadept.editing.goto_line }

keys.ck         = {
      function()
        buffer:line_end_extend()
        buffer:cut()
      end
    }

keys.cu         = { buffer.del_line_left, buffer }



keys['esc']   = {
  ['\b']        = { buffer.del_word_left, buffer },
  d             = { buffer.del_word_right, buffer },

  b             = { buffer.word_left, buffer },
  f             = { buffer.word_right, buffer },

  g             = { textadept.bookmarks.goto_bookmark },

  r             = { ui.find.replace },

  n             = { ui.goto_view, 1, true },
  p             = { ui.goto_view, -1, true },

  x             = { ui.command_entry.focus },

  w             = { function(v) v:unsplit() return true end, view },
  cw            = { function() while view:unsplit() do end end },

  ['/']         = { textadept.editing.block_comment },

--  i             = { COM.indent.indent_buffer },
--  [' ']         = { COM.complete.complete_buffer },
  
--  ['0']         = { COM.debugon },

} -- keys(esc)

