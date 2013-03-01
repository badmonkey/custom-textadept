-- Copyright 2007-2013 Mitchell mitchell.att.foicica.com. See LICENSE.

local M = {}

--[[ This comment is for LuaDoc.
---
-- The python module.
-- It provides utilities for editing Python code.
--
-- ## Key Bindings
--
-- + `Ctrl+L, M` (`⌘L, M` on Mac OSX | `M-L, M` in ncurses)
--   Open this module for editing.
-- + `.`
--   When to the right of a known symbol, show an autocompletion list of fields
--   and functions.
-- + `Shift+Enter` (`⇧↩` | `S-Enter`)
--   Add ':' to the end of the current line and insert a newline.
-- @field sense
--   The Python [Adeptsense](_M.textadept.adeptsense.html).
--   It loads user tags from *`_USERHOME`/modules/python/tags* and user apidocs
--   from *`_USERHOME`/modules/python/api*.
module('_M.python')]]

local m_editing, m_run = _M.textadept.editing, _M.textadept.run
-- Comment string tables use lexer names.
m_editing.comment_string.python = '#'
-- Compile and Run command tables use file extensions.
m_run.run_command.py = 'python %(filename)'
m_run.error_detail.python = {
  pattern = '^%s*File%s+"([^"]+)",%s+line%s+(%d+)',
  filename = 1, line = 2
}

---
-- Sets default buffer properties for Python files.
-- @name set_buffer_properties
function M.set_buffer_properties()
  buffer.use_tabs = false
  buffer.tab_width = 4
end

-- Adeptsense.

M.sense = _M.textadept.adeptsense.new('python')
local as = _M.textadept.adeptsense
M.sense.ctags_kinds = {
  c = as.CLASS, f = as.FUNCTION, m = as.FIELD, M = as.CLASS
}
M.sense:load_ctags(_HOME..'/modules/python/tags', true)
M.sense.api_files = {_HOME..'/modules/python/api'}
M.sense.syntax.class_definition = '^%s*class%s+([%w_:]+)%s*%(?%s*([%w_.]*)'
M.sense.syntax.type_declarations = {
  '%_%s*=%s*([%u][%w_.]+)%s*%b()%s*$'
}
M.sense.syntax.type_assignments = {
  ['^[\'"]'] = 'str',
  ['^%('] = 'tuple',
  ['^%['] = 'list',
  ['^{'] = 'dict',
  ['^open%s*%b()%s*$'] = 'file'
}
M.sense:add_trigger('.')

local ALWAYS = function(inside) return true end -- for symbol_syntax

-- Map of symbols to their syntax definitions.
-- This is used for type inference (e.g. 'string' or [array]) when determining
-- a syntax pattern's class. Each key is the symbol name with a table value
-- whose keys are patt and condition. The patt key has a Lua pattern that
-- matches an instance of the symbol (e.g. a string or array literal) and has
-- 3 captures: starting delimiter, text between delimiters, and ending
-- delimiter. The condition key has a function that accepts a single parameter,
-- the text between delimiters, and returns true or false depending on whether
-- or not the matched pattern is an instance of a symbol.
-- @class table
-- @name symbol_syntax
local symbol_syntax = {
  str = {patt = '([\'"])(.-)(%1)%s*%.([%w_]*)$', condition = ALWAYS},
  list = {patt = '%s(%[)(.-)(%])%s*%.([%w_]*)$', condition = ALWAYS},
  dict = {patt = '({)(.-)(})%s*%.([%w_]*)$', condition = function(inside)
            if inside:find('^%s*$') then return true end
            return inside:find('[%w_]:')
          end},
}

-- Returns a full symbol (if any) and current symbol part (if any) behind the
-- caret.
-- Tries type inference (e.g. 'string'. or [array].) first before falling back
-- on the normal adeptense.get_symbol() method.
function M.sense:get_symbol()
  local line, p = buffer:get_cur_line()
  line = ' '..line:sub(1, p)
  for symbol, syntax in pairs(symbol_syntax) do
    local c1, inside, c2, part = line:match(syntax.patt)
    if c1 and c2 and syntax.condition(inside) then return symbol, part end
  end
  return self.super.get_symbol(self)
end

-- Returns the class name for a given symbol.
-- Tries the normal method based on sense.syntax.type_declarations before
-- falling back on method based on type inference (e.g. foo = 'string').
-- @param symbol The symbol to get the class of.
function M.sense:get_class(symbol)
  local class = self.super.get_class(self, symbol)
  if class then return class end
  -- Integers and Floats.
  if tonumber(symbol:match('^%d+%.?%d*$')) then
    return symbol:find('%.') and 'float' or 'int'
  end
  return nil
end

-- Load user tags and apidoc.
if lfs.attributes(_USERHOME..'/modules/python/tags') then
  M.sense:load_ctags(_USERHOME..'/modules/python/tags')
end
if lfs.attributes(_USERHOME..'/modules/python/api') then
  M.sense.api_files[#M.sense.api_files + 1] = _USERHOME..'/modules/python/api'
end

-- Commands.

-- Indent on 'Enter' after a ':' or auto-indent on ':'.
events.connect(events.CHAR_ADDED, function(ch)
  if buffer:get_lexer() ~= 'python' or (ch ~= 10 and ch ~= 58) then return end
  local buffer = buffer
  local l = buffer:line_from_position(buffer.current_pos)
  if l > 0 then
    local line = buffer:get_line(l - (ch == 10 and 1 or 0))
    if ch == 10 and line:find(':%s+$') then
      buffer.line_indentation[l] = buffer.line_indentation[l - 1] +
                                   buffer.tab_width
      buffer:goto_pos(buffer.line_indent_position[l])
    elseif ch == 58 and (line:find('^%s*else%s*:') or
                         line:find('^%s*elif[^:]+:') or
                         line:find('^%s*except[^:]*:') or
                         line:find('^%s*finally%s*:')) then
      local try = not line:find('^%s*el')
      for i = l - 1, 0, -1 do
        line = buffer:get_line(i)
        if buffer.line_indentation[i] <= buffer.line_indentation[l] and
           (not try and (line:find('^%s*if[^:]+:%s+$') or
                         line:find('^%s*while[^:]+:%s+$') or
                         line:find('^%s*for[^:]+:%s+$')) or
            line:find('^%s*try%s*:%s+$')) then
          local pos, s = buffer.current_pos, buffer.line_indent_position[l]
          buffer.line_indentation[l] = buffer.line_indentation[i]
          buffer:goto_pos(pos + buffer.line_indent_position[l] - s)
          break
        end
      end
    end
  end
end)

-- Show syntax errors as annotations.
events.connect(events.FILE_AFTER_SAVE, function()
  if buffer:get_lexer() ~= 'python' then return end
  local buffer = buffer
  buffer:annotation_clear_all()
  local filename = buffer.filename:iconv(_CHARSET, 'UTF-8')
  local p = io.popen('python -m py_compile "'..filename..'" 2>&1')
  local out = p:read('*all')
  p:close()
  if out:match('^SyntaxError') then
    local line = out:match(filename..'\',%s+(%d+)')
    if line and tonumber(line) > 0 then
      buffer.annotation_visible = 2
      buffer.annotation_text[line - 1] = 'SyntaxError: invalid syntax'
      buffer.annotation_style[line - 1] = 8 -- error style number
      buffer:goto_line(line - 1)
    end
  end
end)

---
-- Container for Python-specific key bindings.
-- @class table
-- @name _G.keys.python
keys.python = {
  [keys.LANGUAGE_MODULE_PREFIX] = {
    m = {io.open_file,
         (_HOME..'/modules/python/init.lua'):iconv('UTF-8', _CHARSET)},
  },
  ['s\n'] = function()
    buffer:line_end()
    buffer:add_text(':')
    buffer:new_line()
  end,
}

-- Snippets.

if type(snippets) == 'table' then
---
-- Container for Python-specific snippets.
-- @class table
-- @name _G.snippets.python
  snippets.python = {
    ['.'] = 'self.',
    __ = '__%1(init)__',
    def = 'def %1(name)(%2(arg)):\n\t%3("""%4\n\t"""\n\t)',
    defs = 'def %1(name)(self%2(, %3(arg))):\n\t%4("""%5\n\t"""\n\t)',
    ifmain = 'if __name__ == "__main__":\n\t%1(main())',
    class = [[
class %1(ClassName)(%2(object)):
	"""%3(documentation)
	"""
	def __init__(self%4(, %5(arg))):
		%6(super(%1, self).__init__())]],
    try = [[
try:
	%0
except %2(Exception), %3(e):
	%4(pass)%5(
finally:
	%6(pass))]]
  }
end

return M
