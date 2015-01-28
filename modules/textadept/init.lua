
local M = {}
textadept = M


M.bookmarks = require 'textadept.bookmarks'

require 'textadept.command_entry'

M.editing = require 'textadept.editing'
M.file_types = require 'textadept.file_types'

require 'textadept.find'

M.run = require 'textadept.run'
M.session = require 'textadept.session'
M.snippets = require 'textadept.snippets'

-- These need to be loaded last.
M.keys = require 'textadept.keys'
--M.menu = require 'textadept.menu'

return M
