--------------------------------------------------------------------------------
-- The MIT License
--
-- Copyright (c) 2010 Brian Schott
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--------------------------------------------------------------------------------

module('_m.common.selectall', package.seeall)
local c = _SCINTILLA.constants

--------------------------------------------------------------------------------
-- Multi-select all occurances of the word at the cursor position
--------------------------------------------------------------------------------
function selectAll()
	-- Grab the word that was clicked on
	buffer:word_left()
	buffer:word_right_extend()
	needle = buffer:get_sel_text()
	-- Trim any whitespace
	needle = needle:gsub('%s', '')
	-- Escape unwanted characters
	needle = needle:gsub('([().*+?^$%%[%]-])', '%%%1')

	-- Don't look for zero-length strings
	if #needle > 0 then
		for i = 0, buffer.line_count do
			text = buffer:get_line(i)
            first, last = text:find("[^%w_]"..needle.."[^%w_]")
            if first == nil then
               first, last = text:find("^"..needle.."[^%w_]")
               if first ~= nil then first = first - 1 end
            end
			-- Setting the selection will get messed up on consecutive loops,
			-- because the selection returned by find() will change as the sub()
			-- function changes the length of text.
			-- store the most recent value of last here
			prev = 0
			-- The loop is to make sure that all occurances of the needle are
			-- marked, not just the first
			while first ~= nil do
				-- And use the prev variable here
				-- the random subtraction of 1 is due to Scintilla being
				-- zero-based for array indices and lua using one.
				local lineStart = buffer:position_from_line(i)
				local selStart = lineStart + first + prev
				local selEnd = lineStart + last - 1
				if selStart ~= buffer.selection_start then
					buffer:add_selection(selEnd, selStart)
				end
				prev = prev + last - 1
				text = text:sub(last, #text)
				first, last = text:find("[^%w_]"..needle.."[^%w_]")
			end
		end
	end
end
