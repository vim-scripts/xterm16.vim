" xterm16 color scheme file
" Maintainer:	Gautam Iyer <gautam@math.uchicago.edu>
" Created:	Thu 16 Oct 2003 06:17:47 PM CDT
" 
" Sets colors for a 16 color terminal. Can be used with 8 color terminals
" provided VIM is configured to set the bold attribute for higher colors.
" Defines GUI colors to be identical to the terminal colors

set bg=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name = 'xterm16'

" cterm colors
hi normal	cterm=none	ctermfg=grey		ctermbg=black

hi cursor	cterm=none	ctermfg=black		ctermbg=green
hi incsearch	cterm=none	ctermfg=grey		ctermbg=darkblue
hi moremsg	cterm=bold	ctermfg=green		ctermbg=none
hi nontext	cterm=none	ctermfg=blue		ctermbg=none
hi search	cterm=none	ctermfg=black		ctermbg=darkcyan
hi specialkey	cterm=none	ctermfg=blue		ctermbg=none
hi statusline	cterm=none	ctermfg=darkblue	ctermbg=grey
hi statuslinenc	cterm=reverse	ctermfg=none		ctermbg=none
hi visual	cterm=none	ctermfg=none		ctermbg=darkblue
hi visualnos	cterm=none	ctermfg=none		ctermbg=darkgrey
hi warningmsg	cterm=bold	ctermfg=red		ctermbg=none

hi comment	cterm=none	ctermfg=darkred		ctermbg=none
hi constant	cterm=none	ctermfg=darkyellow	ctermbg=none
hi htmlitalic	cterm=none	ctermfg=yellow		ctermbg=none
hi htmlbolditalic cterm=bold	ctermfg=yellow		ctermbg=none
hi identifier	cterm=none	ctermfg=darkcyan	ctermbg=none
hi ignore	cterm=none	ctermfg=darkgrey	ctermbg=none
hi special	cterm=none	ctermfg=darkgreen	ctermbg=none
hi preproc	cterm=none	ctermfg=blue		ctermbg=none
hi spellerrors	cterm=bold	ctermfg=darkred 	ctermbg=none
hi statement	cterm=none	ctermfg=cyan 		ctermbg=none
hi type		cterm=none	ctermfg=green		ctermbg=none
hi underlined	cterm=none	ctermfg=darkmagenta	ctermbg=none

" define gui colors to be exactly the same as xterm colors

let s:none		= 'NONE'
let s:black		= '#000000'
let s:darkred		= '#CD0000'
let s:darkgreen		= '#00CD00'
let s:darkyellow	= '#CDCD00'
let s:darkblue		= '#0000FF'
let s:darkmagenta	= '#CD00CD'
let s:darkcyan		= '#00CDCD'
let s:grey		= '#C0C0C0'
let s:darkgrey		= '#808080'
let s:red		= '#FF0000'
let s:green		= '#00FF00'
let s:yellow		= '#FFFF00'
let s:blue		= '#0080FF'
let s:magenta		= '#FF00FF'
let s:cyan		= '#00FFFF'
let s:white		= '#FFFFFF'

" set the hilight groups for gui

exec "hi normal	      gui=none	guifg=".s:grey	"guibg=".s:black

exec "hi cursor	      gui=bold	guifg=".s:black		"guibg=".s:green
exec "hi incsearch    gui=none	guifg=".s:grey		"guibg=".s:darkblue
exec "hi moremsg      gui=bold	guifg=".s:green		"guibg=".s:none
exec "hi nontext      gui=none	guifg=".s:blue		"guibg=".s:none
exec "hi search	      gui=none	guifg=".s:black		"guibg=".s:darkcyan
exec "hi specialkey   gui=none	guifg=".s:blue		"guibg=".s:none
exec "hi statusline   gui=none	guifg=".s:darkblue	"guibg=".s:grey
exec "hi statuslinenc gui=none	guifg=".s:black		"guibg=".s:grey
exec "hi visual       gui=none	guifg=".s:none		"guibg=".s:darkblue
exec "hi visualnos    gui=none	guifg=".s:none		"guibg=".s:darkgrey
exec "hi warningmsg   gui=bold	guifg=".s:red		"guibg=".s:none

exec "hi comment      gui=none	guifg=".s:darkred	"guibg=".s:none
exec "hi constant     gui=none	guifg=".s:darkyellow	"guibg=".s:none
exec "hi htmlitalic   gui=none	guifg=".s:yellow	"guibg=".s:none
exec "hi htmlbolditalic gui=bold guifg=".s:yellow	"guibg=".s:none
exec "hi identifier   gui=none	guifg=".s:darkcyan	"guibg=".s:none
exec "hi ignore       gui=none	guifg=".s:darkgrey	"guibg=".s:none
exec "hi special      gui=none	guifg=".s:darkgreen	"guibg=".s:none
exec "hi preproc      gui=none	guifg=".s:blue		"guibg=".s:none
exec "hi spellerrors  gui=bold	guifg=".s:darkred 	"guibg=".s:none
exec "hi statement    gui=none	guifg=".s:cyan 		"guibg=".s:none
exec "hi type	      gui=none	guifg=".s:green		"guibg=".s:none
exec "hi underlined   gui=none	guifg=".s:darkmagenta	"guibg=".s:none
