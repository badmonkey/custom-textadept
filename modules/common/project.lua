-- The __common.project__ module tries to figure out the project root directory
-- for a given file. If you have a directory structure
-- like
--     code
--       project1
--         src
--           file1.lua
--       project2
--         src
-- the function __root__ returns *project1* for `file1.lua`
-- if `code` is part of the `common.project.DIRS` table.
-- If the project root is not found in `DIRS` the file's directory is returned.

local M = {}


-- Read environment variable.
if WIN32 then
  HOMEPAT = os.getenv('USERPROFILE')..'\\'
  HOMESUB = ''
else
  HOMEPAT = '^'..os.getenv('HOME')
  HOMESUB = 'HOME'
end

-- ## Fields

-- This `DIRS` field can be overwritten or added to in your `init.lua` after
-- the _common_ module has been loaded, for example:
--     _m.common.project.DIRS = { _USERHOME..'/modules',
--                                '/home/username/code',
--                                '/home/username/projects' }
-- The default value contains Textadept's directory and the user's
-- modules directory.
M.DIRS = { _HOME }

-- ## Commands


-- Match a file's path with project root directories and try to return the
-- project root.  If the project root is not found the file's directory
-- is returned.
function M.root(filename)
  local filename = filename or buffer.filename
  local project_root

  if filename then
    for i = 1, #M.DIRS do
      project_root = filename:match('^('..M.DIRS[i]..')[/\\].+')
	  
	  if project_root then
          break
	  end
	  
    end
  end

  return project_root or filename:match('(.+)[/\\]') or '', project_root and true
end


function M.get_name(filename)
  local root, realproj = M.root(filename)

  if realproj then
    filename = filename:gsub("^"..root, root:match('[^/\\]+$'):upper() )
  end
  
  return filename:gsub(HOMEPAT, HOMESUB), filename:match('[^/\\]+$'), root
end


return M
