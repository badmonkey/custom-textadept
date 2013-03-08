

local TA = require 'textadept'


EXCLUDE_FILTERS = {
  '^~%.', '!%.h$', '!%.cpp$', '!%.c$', '!%.remedy$', '!%.lua$',

  folders = { '%.hg', '%.svn', '%.git' }
}
--DEFAULT_DEPTH=4
--MAX=1000

SUFFIX_PAIRS = {
  ['.cc'] = '.h';
  ['.cpp'] = '.h';
  ['.h'] = '.cc';

}

local colours = {
    red = "#FF0000", blue = '#0000FF', green = '#00FF00',
    pink ="#FFAAAA" , black = '#000000', lightblue = '#AAAAFF', lightgreen = '#AAFFAA'
  }

function colour_parse(str)
  if str:sub(1,1) ~= '#' then
    str = colours[str]
  end
  return tonumber(str:sub(6,7)..std:sub(4,5)..str:sub(2,4),16)
end


function string:endswith(endding)
   return endding == '' or self:sub(-endding:len()) == endding
end




local COM = require 'common'


COM.project.DIRS = {
    '/home/faganm/projects',
    '/opt/projects',
    '/opt/textadept',
    _USERHOME
  }


require 'textadept.complete'


--[=[
gui.dialog('ok-msgbox',
	    '--text', 'theming callback',
	    '--informative‑text', 'more informative text',
	    '--button1', _L['_OK'])
]=]

  
  