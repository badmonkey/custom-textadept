
local COM = {}
_M.common = COM


COM.project = require 'common.project'
COM.display_filename = require 'common.display_filename'

COM.lastbuffer = require 'common.lastbuffer'


--[=[

require 'common.theming'

require 'common.filename'
require 'common.multiedit'

require 'common.enclose'
require 'common.ctags'
require 'common.ack'
]=]


return COM
