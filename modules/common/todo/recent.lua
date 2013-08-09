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

--------------------------------------------------------------------------------
-- This module persists the recently-used file list across restarts.
-- Version 0.1
--
-- History:
--     * Version 0.1 - First release
--------------------------------------------------------------------------------

module("_m.textadept.recent", package.seeall)

local events = _G.events
local locale = _G.locale
local gui = gui
local io = _G.io
local RECENT_FILES = _USERHOME.."/recent"

-- Maximum number of files to keep in the list
maxFiles = 10

-- Load the recently used files list
local f = io.open(RECENT_FILES, "rb")
if f then
	for line in f:lines() do
		if line ~= locale.MESSAGE_BUFFER and line ~= locale.UNTITLED
				and line ~= locale.ERROR_BUFFER then
			table.insert(io.recent_files, line)
		end
	end
	f:close()
end


-- Add each file to the recently opened list as they are opened
events.connect("file_opened",
	function(filename)
		-- Check to see if the file is already in the list
		local add = true
		for _, n in ipairs(io.recent_files) do
			if n == filename then add = false break end
		end
		-- Add new file to the beginning of the list
		if add then table.insert(io.recent_files, filename) end
		-- Trim the list to length
		while #io.recent_files > maxFiles do
			table.remove(io.recent_files)
		end
		f = io.open(RECENT_FILES, "wb")
		if f then
			for _, n in ipairs(io.recent_files) do
				f:write(n.."\n")
			end
			f:close()
		end
	end)
