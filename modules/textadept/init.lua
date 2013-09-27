
local TA = {}
_M.textadept = TA


TA.adeptsense = require 'textadept.adeptsense'
TA.bookmarks = require 'textadept.bookmarks'

require 'textadept.command_entry'

TA.editing = require 'textadept.editing'

require 'textadept.find'

TA.file_types = require 'textadept.file_types'
TA.run = require 'textadept.run'
TA.session = require 'textadept.session'
TA.snippets = require 'textadept.snippets'


-- keys and menu are handled in keybindings.lua


return TA
