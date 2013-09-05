
local COM = {}
_M.common = COM


COM.project = require 'common.project'
COM.display_filename = require 'common.display_filename'

COM.lastbuffer = require 'common.lastbuffer'

COM.filename = require 'common.filename'
COM.ctags = require 'common.ctags'
COM.ack = require 'common.ack'


--[=[
require 'common.multiedit'
require 'common.enclose'
]=]


return COM
