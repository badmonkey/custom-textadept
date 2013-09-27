
local COM = {}
_M.common = COM


COM.project = require 'common.project'
COM.display_filename = require 'common.display_filename'

COM.lastbuffer = require 'common.lastbuffer'

COM.filename = require 'common.filename'
COM.ctags = require 'common.ctags'
COM.ack = require 'common.ack'

COM.indent = require 'common.indent'
COM.complete = require 'common.complete'


--[=[
require 'common.multiedit'
require 'common.enclose'
]=]

COM.debug_mode = false

function COM.debugon()
  ui.print("DEBUG Mode On")
  COM.debug_mode = true
end


function ui.debug_print(...)
	if COM.debug_mode then
		ui.print(...)
	end
end


return COM
