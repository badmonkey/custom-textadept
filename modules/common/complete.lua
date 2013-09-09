function complete_cpp()
  -- written by JB Mouret -- mouret@isir.upmc.fr
  local buffer = buffer
  -- configure here your path to clang
  local cmd ="clang++ "
  cmd = cmd.." -cc1 -fsyntax-only -fno-caret-diagnostics"
  -- add common paths (add yours)
  cmd = cmd.." -I /usr/local/include/ "
  cmd = cmd.." -I. -I.. -I../.."
  cmd = cmd.." -fdiagnostics-print-source-range-info"
  cmd = cmd.." -code-completion-at="
  line = ""..(buffer:line_from_position(buffer.current_pos) + 1);
  col = ""..(buffer.column[buffer.current_pos]+1)
  cmd = cmd..buffer.filename ..":"..line..":"..col.." "..buffer.filename
  buffer:save()
  local p = io.popen(cmd)
  local s = ""
  for line in p:lines() do
      local tag_name= line:match('^COMPLETION: (.+) :')
      if tag_name ~= nil then
        local s1 = string.gsub(tag_name, "(%W)", "%%%1")
        if (s:find(s1) == nil) then
          s = s..tag_name.." "
        end
      end
  end
  buffer.auto_c_show(buffer, 0, s)
end
To bind this function to control+i:

_G.keys.cpp.ci = complete_cpp

