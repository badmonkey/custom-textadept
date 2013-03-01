module("_m.common.compiler", package.seeall)

local gui = gui

function showErrorsInline(command, errorPattern, indicies)
	local filepath = buffer.filename:iconv(_CHARSET, 'UTF-8')
	local filedir, filename
	if filepath:find('[/\\]') then
		filedir, filename = filepath:match('^(.+[/\\])([^/\\]+)$')
	else
		filedir, filename = '', filepath
	end
	local filename_noext = filename:match('^(.+)%.')

	local current_dir = lfs.currentdir()
	lfs.chdir(filedir)
	command = command:gsub("__FILENAME__", filename)
	local p = io.popen(command..' 2>&1')
	local out = p:read('*all')
	p:close()
	lfs.chdir(current_dir)
	buffer:marker_delete_all(16)
	buffer:marker_define(16, _SCINTILLA.constants.SC_MARK_ROUNDRECT)
	buffer:marker_set_back(16, 0x0000ff)
	buffer:annotation_clear_all()
	buffer.annotation_visible = 2
	out = out:gsub("^%s+", "")
	out = out:gsub("%s+$", "")
	if out == "" then return end
	out = out.."\n"
	local errorCount = 0
	for j in string.gmatch(out, "(.-)\n") do
		errorCount = errorCount + 1
		parts = {}
		parts[1], parts[2], parts[3] = string.match(j, errorPattern)
		errorFileName, errorFileLine, errorMessage = parts[indicies.file], parts[indicies.line], parts[indicies.message];
		if errorFileName == filename then
			local lineNum = tonumber(errorFileLine) - 1
			buffer:marker_add(lineNum, 16)
			buffer:annotation_set_text(lineNum, errorMessage)
			buffer.annotation_style[lineNum] = 8
		end
	end
	--print(string.format("%d Errors", errorCount))
	--gui.dialog('ok-msgbox', '--title', 'D Compile', '--informative-text',
	--	string.format("%d Errors", errorCount), '--no-cancel')
end
