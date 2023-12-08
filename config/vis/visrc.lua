-- load standard vis module, providing parts of the Lua API
require('vis')
-- load plugin called `<name>` (notice the omission of the `.lua` file extension)
require('plugins/vis-cursors/init') -- https://github.com/erf/vis-cursors.git

vis.events.subscribe(vis.events.INIT, function()
-- global configuration options
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- per window configuration options
	vis:command('set autoindent')
	vis:command('set relativenumber')
	vis:command('set cursorline')
	vis:command('set expandtab off')
	vis:command('set show-tabs')
	vis:command('set ignorecase')
	--vis:command('set theme light-16')
	--vis:command('set theme dark-16')
	vis:command('set theme default-256')
	vis:command('set show-eof')
	vis:command('set show-newline')
	vis:command('set colorcolumn 80')
end)
