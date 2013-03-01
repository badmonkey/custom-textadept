
local TA = {}
_M.textadept = TA


TA.adeptsense = require 'textadept.adeptsense'
TA.bookmarks = require 'textadept.bookmarks'

require 'textadept.command_entry'

TA.editing = require 'textadept.editing'

require 'textadept.find'

TA.filter_through = require 'textadept.filter_through'
TA.mime_types = require 'textadept.mime_types'
TA.run = require 'textadept.run'
TA.session = require 'textadept.session'
TA.snapopen = require 'textadept.snapopen'
TA.snippets = require 'textadept.snippets'


return TA
