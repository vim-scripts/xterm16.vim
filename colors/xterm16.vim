" xterm16 color scheme file
" Maintainer:	Gautam Iyer <gautam@math.uchicago.edu>
" Created:	Thu 16 Oct 2003 06:17:47 PM CDT
" Modified:	Sat 13 Nov 2004 05:58:53 PM CST
"
" Sets colors for a 16 color terminal. Can be used with 8 color terminals
" provided VIM is configured to set the bold attribute for higher colors.
" Defines GUI colors to be identical to the terminal colors

let s:cpo_save = &cpo
set cpo&vim		" line continuation is used

set bg=dark

hi clear

if exists('syntax_on')
    syntax reset
endif
let colors_name = 'xterm16'

" {{{1 Local function definitions
" {{{2 tohex(n): Convert a number to a 2 digit hex
let s:hex = '0123456789abcdef'
function s:tohex( n)
    return a:n > 255 ? 'ff' : s:hex[a:n / 16] . s:hex[a:n % 16]
endfunction

" {{{2 extractRGB( string): Extract r,g,b components from string into s:c1,2,3
function s:extractRGB( string)
    if a:string =~ '^#[0-9a-f]\{6\}$'
	" Colors in hex values
	let s:c1 = '0x' . strpart(a:string, 1, 2)
	let s:c2 = '0x' . strpart(a:string, 3, 2)
	let s:c3 = '0x' . strpart(a:string, 5, 2)

    elseif a:string =~ '^\d\{3\}$'
	" Colors in cterm values
	let s:c1 = s:guilevel( a:string[0])
	let s:c2 = s:guilevel( a:string[1])
	let s:c3 = s:guilevel( a:string[2])

    elseif a:string =~ '^[lmh][0-9]\{6\}'
	" Colors in propotions of low / med / high
	if exists('s:'.a:string[0])
	    let l:level = s:{a:string[0]}
	    let s:c1 = l:level * strpart(a:string, 1, 2) / 50
	    let s:c2 = l:level * strpart(a:string, 3, 2) / 50
	    let s:c3 = l:level * strpart(a:string, 5, 2) / 50
	else
	    throw 'xterm16 Error: Use of propotional intensities before absolute intensities'
	endif
    else
	throw 'xterm16 Error: Brightness / color "'. a:string . '" badly formed.'
    endif
endfunction

" {{{2 guilevel(n) : Get the gui intensity of a given cterm intensity
function s:guilevel( n)
    " 0 95 135 175 215 255
    return a:n == 0 ? 0 : 95 + 40 * (a:n - 1)
endfunction

" {{{2 trmlevel(n) : Get the cterm intensity of a given gui intensity
function s:trmlevel( n)
    " 0 -- [0, 48], 1 -- [49, 115], 2 -- [116, 155], 3 -- [156, 195], 4 -- [196, 235], 5 -- [236, 255]
    if a:n <= 48
	return 0
    elseif a:n <= 115
	return 1
    else
	return a:n > 255 ?  5 : (a:n - 116) / 40 + 2
    endif
endfunction

" {{{2 guicolor( r, g, b): Return the gui color with intensities r,g,b
function s:guicolor( r, g, b)
    return '#' . s:tohex(a:r) . s:tohex(a:g) . s:tohex(a:b)
endfunction

" {{{2 trmcolor( r, g, b): Return the xterm-256 color with intensities r, g, b
function s:trmcolor( r, g, b)
    if a:r == a:g && a:r == a:b
	" Grey scale ramp
	if a:r <= 4
	    return 16
	elseif a:r <= 243
	    return (a:r - 4) / 10 + 232
	else
	    return a:r > 247 ? 231 : 255
	endif
    else
	return s:trmlevel(a:r) * 36 + s:trmlevel(a:g) * 6 + s:trmlevel(a:b) + 16
    endif
endfunction

" {{{2 setcolor( name, r, g, b): Set the script variables gui_name and trm_name
function s:setcolor( name, r, g, b)
    if exists('g:xterm16_'.a:name)
	" Use user-defined color settings (from global variable)
	call s:extractRGB( g:xterm16_{a:name})

	let s:gui_{a:name} = s:guicolor( s:c1, s:c2, s:c3)
	let s:trm_{a:name} = s:trmcolor( s:c1, s:c2, s:c3)
    else
	" Set the GUI / cterm color from r,g,b
	let s:gui_{a:name} = s:guicolor( a:r, a:g, a:b)
	let s:trm_{a:name} = ( &t_Co == 256 ? s:trmcolor( a:r, a:g, a:b) : a:name)
    endif

    " Add the color to palette
    let g:xterm16_palette = g:xterm16_palette . "\n" . s:gui_{a:name} . ' ' . a:name
endfunction

" {{{2 hi( group, attr, fg, bg): Set the gui/cterm highlighting groups
" group - groupname. attr - attributes. fg/bg color name.
function s:hi( group, attr, fg, bg, ...)
    if has('gui_running')
	if exists('g:xterm16fg_' . a:group)
	    call s:extractRGB( g:xterm16fg_{a:group} )
	    let l:fg = s:guicolor( s:c1, s:c2, s:c3)
	else
	    let l:fg = s:gui_{( a:0 >= 2 ) ? a:2 : a:fg}
	endif

	if exists('g:xterm16bg_' . a:group)
	    call s:extractRGB( g:xterm16bg_{a:group} )
	    let l:bg = s:guicolor( s:c1, s:c2, s:c3)
	else
	    let l:bg = s:gui_{( a:0 == 3 ) ? a:3 : a:bg}
	endif

	if exists('g:xterm16attr_' . a:group)
	    let l:attr = g:xterm16attr_{a:group}
	else
	    let l:attr = (a:0 >= 1) ? a:1 : a:attr
	endif

	exec 'hi' a:group 'gui='.l:attr 'guifg='.l:fg 'guibg='.l:bg
    elseif &t_Co == 256
	if exists('g:xterm16fg_' . a:group)
	    call s:extractRGB( g:xterm16fg_{a:group} )
	    let l:fg = s:trmcolor( s:c1, s:c2, s:c3)
	else
	    let l:fg = s:trm_{a:fg}
	endif

	if exists('g:xterm16bg_' . a:group)
	    call s:extractRGB( g:xterm16bg_{a:group} )
	    let l:bg = s:trmcolor( s:c1, s:c2, s:c3)
	else
	    let l:bg = s:trm_{a:bg}
	endif

	if exists('g:xterm16attr_' . a:group)
	    let l:attr = g:xterm16attr_{a:group}
	else
	    let l:attr = a:attr
	endif

	exec 'hi' a:group 'cterm='.l:attr 'ctermfg='.l:fg 'ctermbg='.l:bg
    else
	exec 'hi' a:group 'cterm='.a:attr 'ctermfg='.a:fg 'ctermbg='.a:bg
    endif
endfunction

" {{{2 set_brightness( default): Set s:brightness based on default
function s:set_brightness( default)
    if !exists('g:xterm16_brightness')
	let s:brightness = a:default
    elseif  g:xterm16_brightness == 'high'
	let s:brightness = '134'
    elseif g:xterm16_brightness == 'low'
	let s:brightness = '123'
    else
	let s:brightness = g:xterm16_brightness
    endif
endfunction

" {{{1 Global functions and initialisations.
command! -nargs=* Brightness 	if Brightness(<f-args>)<bar>colo xterm16<bar>endif

" {{{2 Brightness( brightness, colormap)
function! Brightness(...)
    if a:0 == 0
	echo "Brightness: ".s:brightness.", Colormap: ".s:colormap
	return 0
    elseif a:0 > 2
	echoerr 'Too many arguements.'
	return 0
    endif

    let g:xterm16_brightness = a:1
    if a:0 == 2
	let g:xterm16_colormap = a:2
    endif

    return 1
endfunction
" }}}1

try
    " {{{1 Setup defaults
    " {{{2 Get colormap defaults in "s:colormap"
    " On a terminal (without 256 colors), use "standard" colormap. Otherwise
    " use value from "g:xterm16_colormap" if exists, or "soft" as default.
    if !has('gui_running') && &t_Co != 256
	let s:colormap = 'standard'
    elseif exists('g:xterm16_colormap')
	let s:colormap = g:xterm16_colormap
    else
	let s:colormap = 'soft'
    endif

    " {{{2 Redefine a few colors for CRT monitors
    if exists('g:xterm16_CRTColors')
	if s:colormap == 'standard'
	    let g:xterm16_darkblue	= 'h000050'
	    let g:xterm16_blue		= 'h002550'
	    let g:xterm16_grey		= 'm474747'

	    unlet! g:xterm16_skyblue g:xterm16_green g:xterm16_bluegreen

	    call s:set_brightness( '#80cdff')
	else
	    let g:xterm16_skyblue	= 'h003550'
	    let g:xterm16_green		= 'm315000'
	    let g:xterm16_bluegreen	= 'm005031'

	    unlet! g:xterm16_darkblue g:xterm16_blue g:xterm16_grey

	    call s:set_brightness ( '345')
	endif
    else
	call s:set_brightness( '134')
    endif

    unlet! s:c1 s:c2 s:c3
    call s:extractRGB(s:brightness)
    let s:l = s:c1
    let s:m = s:c2
    let s:h = s:c3

    " {{{2 Set a bright green cursor
    if !exists('g:xterm16bg_Cursor')
	let g:xterm16bg_Cursor		= '#00ff00'
    endif

    " {{{2 Set the current pallete:
    let g:xterm16_palette = 'Current palette (Brightness: '.s:brightness. ', Colormap: '.s:colormap.')'

    " {{{1 Define colors and highlighting groups based on "s:colormap"
    let s:trm_none = 'NONE'
    let s:gui_none = 'NONE'

    if s:colormap == 'standard'
	" {{{2 Original colormap. 8 standard colors, and 8 brighter ones.
	call s:setcolor( 'black',       0,   0,    0)
	call s:setcolor( 'darkred',     s:m, 0,    0)
	call s:setcolor( 'darkgreen',   0,   s:m,  0)
	call s:setcolor( 'darkyellow',  s:m, s:m,  0)
	call s:setcolor( 'darkblue',    0,   0,    s:m)
	call s:setcolor( 'darkmagenta', s:m, 0,    s:m)
	call s:setcolor( 'darkcyan',    0,   s:m,  s:m)
	call s:setcolor( 'grey',        s:m*44/50, s:m*44/50,  s:m*44/50)
	call s:setcolor( 'darkgrey',    s:l, s:l,  s:l)
	call s:setcolor( 'red',         s:h, 0,    0)
	call s:setcolor( 'green',       0,   s:h,  0)
	call s:setcolor( 'yellow',      s:h, s:h,  0)
	call s:setcolor( 'blue',        0,   0,    s:h)
	call s:setcolor( 'magenta',     s:h, 0,    s:h)
	call s:setcolor( 'cyan',        0,   s:h,  s:h)
	call s:setcolor( 'white',       s:h, s:h,  s:h)

	" {{{2 Highlighting groups for standard colors
	call s:hi( 'Normal'       , 'none'   , 'grey'        , 'black'      )

	call s:hi( 'Cursor'       , 'none'   , 'black'       , 'green'      )
	call s:hi( 'DiffAdd'      , 'none'   , 'darkblue'    , 'darkgreen'  )
	call s:hi( 'DiffChange'   , 'none'   , 'black'       , 'darkyellow' )
	call s:hi( 'DiffDelete'   , 'none'   , 'darkblue'    , 'none'       )
	call s:hi( 'DiffText'     , 'none'   , 'darkred'     , 'darkyellow' )
	call s:hi( 'Directory'    , 'none'   , 'cyan'        , 'none'       )
	call s:hi( 'ErrorMsg'     , 'none'   , 'white'       , 'darkred'    )
	call s:hi( 'FoldColumn'   , 'none'   , 'yellow'      , 'darkblue'   )
	call s:hi( 'Folded'       , 'none'   , 'yellow'      , 'darkblue'   )
	call s:hi( 'IncSearch'    , 'none'   , 'grey'        , 'darkblue'   )
	call s:hi( 'LineNr'       , 'none'   , 'yellow'      , 'none'       )
	call s:hi( 'MoreMsg'      , 'bold'   , 'green'       , 'none'       )
	call s:hi( 'NonText'      , 'none'   , 'blue'        , 'none'       )
	call s:hi( 'Question'     , 'none'   , 'green'       , 'none'       )
	call s:hi( 'Search'       , 'none'   , 'black'       , 'darkcyan'   )
	call s:hi( 'SignColumn'   , 'none'   , 'darkmagenta' , 'darkgrey'   )
	call s:hi( 'SpecialKey'   , 'none'   , 'blue'        , 'none'       )
	call s:hi( 'StatusLine'   , 'none'   , 'darkblue'    , 'grey'       )
	call s:hi( 'StatusLineNC' , 'reverse', 'none'        , 'none'       )
	call s:hi( 'Title'        , 'none'   , 'magenta'     , 'none'       )
	call s:hi( 'Visual'       , 'none'   , 'none'        , 'darkblue'   )
	call s:hi( 'VisualNOS'    , 'none'   , 'none'        , 'darkgrey'   )
	call s:hi( 'WarningMsg'   , 'bold'   , 'red'         , 'none'       )
	call s:hi( 'WildMenu'     , 'none'   , 'darkmagenta' , 'darkyellow' )

	call s:hi( 'Comment'      , 'none'   , 'darkred'     , 'none'       )
	call s:hi( 'Constant'     , 'none'   , 'darkyellow'  , 'none'       )
	call s:hi( 'Error'        , 'none'   , 'white'       , 'red'        )
	call s:hi( 'Identifier'   , 'none'   , 'darkcyan'    , 'none'       )
	call s:hi( 'Ignore'       , 'none'   , 'darkgrey'    , 'none'       )
	call s:hi( 'PreProc'      , 'none'   , 'blue'        , 'none'       )
	call s:hi( 'Special'      , 'none'   , 'darkgreen'   , 'none'       )
	call s:hi( 'Statement'    , 'none'   , 'cyan'        , 'none'       )
	call s:hi( 'Todo'         , 'none'   , 'black'       , 'yellow'     )
	call s:hi( 'Type'         , 'none'   , 'green'       , 'none'       )
	call s:hi( 'Underlined'   , 'none'   , 'darkmagenta' , 'none'       )
	" {{{2 Define html highlighting groups for standard colors.
	if !exists("g:xterm16_NoHtmlColors")
	    call s:hi( 'htmlBold',                'none', 'white',       'none', 'bold',                  'none')
	    call s:hi( 'htmlItalic',              'none', 'yellow',      'none', 'italic',                'none')
	    call s:hi( 'htmlUnderline',           'none', 'darkmagenta', 'none', 'underline',             'none')
	    call s:hi( 'htmlBoldItalic',          'bold', 'yellow',      'none', 'bold,italic',           'none')
	    call s:hi( 'htmlBoldUnderline',       'bold', 'magenta',     'none', 'bold,underline',        'none')
	    call s:hi( 'htmlUnderlineItalic',     'none', 'magenta',     'none', 'underline,italic',      'none')
	    call s:hi( 'htmlBoldUnderlineItalic', 'bold', 'white',       'none', 'bold,underline,italic', 'none')

	    hi! link htmlLink PreProc
	endif
	" {{{2 Remap darkblue on linux consoles
	if !exists("g:xterm16_NoRemap") && &term =~# (exists("g:xterm16_TermRegexp") ? xterm16_TermRegexp : "linux")
	    hi! link preproc		underlined
	endif
	" }}}2
    elseif s:colormap == 'soft'
	" {{{2 "soft" colormap. Mix colors and use all colors of similar intensities
	" Background colors
	call s:setcolor( 'black',       0,       0,     0)
	call s:setcolor( 'darkred',     s:l,     0,     0)
	call s:setcolor( 'darkyellow',  s:l,     s:l,   0)
	call s:setcolor( 'darkcyan',    0,       s:l,   s:l)
	call s:setcolor( 'darkblue',    0,       0,     s:l)
	call s:setcolor( 'darkgrey',    s:l/3,   s:l/3, s:l/3)

	" Foreground colors
	call s:setcolor( 'red',         s:h,     0,     0)     " Foreground: Red
	call s:setcolor( 'lightbrown',  s:h,     s:h/2, 0)     " Foreground: Orange / Brown
	call s:setcolor( 'yellow',      s:m,     s:m,   0)     " Foreground: Yellow
	call s:setcolor( 'green',       s:m/2,   s:m,   0)     " Foreground: Yellowish Green
	call s:setcolor( 'bluegreen',   0,       s:m,   s:m/2) " Foreground: Blueish Green
	call s:setcolor( 'skyblue',     0,       s:h/2, s:h)   " Foreground: Sky skyblue
	call s:setcolor( 'magenta',     s:h*3/4, 0,     s:h)   " Foreground: Magenta / Purple
	call s:setcolor( 'cyan',        0,       s:m,   s:m)   " Foreground: Cyan
	call s:setcolor( 'purple',      s:h/2,   s:h/2, s:h)   " Foreground: Light Purple

	" Greys can be done with better accurcy on cterms!
	call s:setcolor( 'white',       s:m*44/50, s:m*44/50,   s:m*44/50)   " Foreground: white

	" {{{2 Highlighting groups for "soft" colors.
	call s:hi( 'Normal'       , 'none'   , 'white'       , 'black'      )

	call s:hi( 'Cursor'       , 'none'   , 'black'       , 'green'      )
	call s:hi( 'DiffAdd'      , 'none'   , 'lightbrown'  , 'darkblue'   )
	call s:hi( 'DiffChange'   , 'none'   , 'black'       , 'darkyellow' )
	call s:hi( 'DiffDelete'   , 'none'   , 'purple'      , 'darkblue'   )
	call s:hi( 'DiffText'     , 'none'   , 'darkred'     , 'darkyellow' )
	call s:hi( 'Directory'    , 'none'   , 'cyan'        , 'none'       )
	call s:hi( 'ErrorMsg'     , 'none'   , 'white'       , 'darkred'    )
	call s:hi( 'FoldColumn'   , 'none'   , 'purple'      , 'darkgrey'   )
	call s:hi( 'Folded'       , 'none'   , 'purple'      , 'darkgrey'   )
	call s:hi( 'IncSearch'    , 'none'   , 'yellow'      , 'darkblue'   )
	call s:hi( 'LineNr'       , 'none'   , 'yellow'      , 'none'       )
	call s:hi( 'MoreMsg'      , 'none'   , 'green'       , 'none'       )
	call s:hi( 'NonText'      , 'none'   , 'yellow'      , 'none'       )
	call s:hi( 'Question'     , 'none'   , 'green'       , 'none'       )
	call s:hi( 'Search'       , 'none'   , 'black'       , 'darkcyan'   )
	call s:hi( 'SignColumn'   , 'none'   , 'yellow'      , 'darkgrey'   )
	call s:hi( 'SpecialKey'   , 'none'   , 'yellow'      , 'none'       )
	call s:hi( 'StatusLine'   , 'none'   , 'yellow'      , 'darkgrey'   )
	call s:hi( 'StatusLineNC' , 'none'   , 'darkcyan'    , 'darkgrey'   )
	call s:hi( 'Title'        , 'none'   , 'yellow'      , 'none'       )
	call s:hi( 'Visual'       , 'none'   , 'none'        , 'darkblue'   )
	call s:hi( 'VisualNOS'    , 'none'   , 'white'       , 'darkgrey'   )
	call s:hi( 'VertSplit'    , 'none'   , 'darkcyan'    , 'darkgrey'   )
	call s:hi( 'WarningMsg'   , 'none'   , 'red'         , 'none'       )
	call s:hi( 'WildMenu'     , 'none'   , 'yellow'      , 'none'       )

	call s:hi( 'Comment'      , 'none'   , 'red'         , 'none'       )
	call s:hi( 'Constant'     , 'none'   , 'lightbrown'  , 'none'       )
	call s:hi( 'Error'        , 'none'   , 'white'       , 'darkred'    )
	call s:hi( 'Identifier'   , 'none'   , 'cyan'        , 'none'       )
	call s:hi( 'Ignore'       , 'none'   , 'darkgrey'    , 'none'       )
	call s:hi( 'PreProc'      , 'none'   , 'purple'      , 'none'       )
	call s:hi( 'Special'      , 'none'   , 'green'       , 'none'       )
	call s:hi( 'Statement'    , 'none'   , 'skyblue'     , 'none'       )
	call s:hi( 'Todo'         , 'none'   , 'black'       , 'darkyellow' )
	call s:hi( 'Type'         , 'none'   , 'bluegreen'   , 'none'       )
	call s:hi( 'Underlined'   , 'none'   , 'magenta'     , 'none'       )

	" {{{2 Define html highlighting groups for soft colors.
	if !exists("g:xterm16_NoHtmlColors")
	    call s:hi( 'htmlBold',                'none', 'yellow',  'none', 'bold',                  'none')
	    call s:hi( 'htmlItalic',              'none', 'yellow',  'none', 'italic',                'none')
	    call s:hi( 'htmlUnderline',           'none', 'magenta', 'none', 'underline',             'none')
	    call s:hi( 'htmlBoldItalic',          'bold', 'yellow',  'none', 'bold,italic',           'none')
	    call s:hi( 'htmlBoldUnderline',       'bold', 'magenta', 'none', 'bold,underline',        'none')
	    call s:hi( 'htmlUnderlineItalic',     'bold', 'magenta', 'none', 'underline,italic',      'none')
	    call s:hi( 'htmlBoldUnderlineItalic', 'bold', 'white',   'none', 'bold,underline,italic', 'none')
	endif
	" }}}2
    else
	throw 'xterm16 Error: Unrecognised colormap "' . s:colormap . '"'
    endif

    " }}}1
catch /^xterm16 Error:/
    " {{{1 Handle internal exceptions.
    unlet colors_name
    echohl ErrorMsg
    echo v:exception
    echohl None
    " }}}1
finally
    " {{{1 Unlet script variables and functions
    " Restore compatibility options
    let &cpo = s:cpo_save
    unlet! s:c1 s:c2 s:c3
    unlet! s:cpo_save s:hex s:l s:m s:h s:trm_none s:gui_none
    unlet! s:gui_black s:gui_darkred s:gui_darkgreen s:gui_darkyellow s:gui_darkblue s:gui_darkmagenta s:gui_darkcyan s:gui_grey s:gui_darkgrey s:gui_red s:gui_green s:gui_yellow s:gui_blue s:gui_magenta s:gui_cyan s:gui_white
    unlet! s:trm_black s:trm_darkred s:trm_darkgreen s:trm_darkyellow s:trm_darkblue s:trm_darkmagenta s:trm_darkcyan s:trm_grey s:trm_darkgrey s:trm_red s:trm_green s:trm_yellow s:trm_blue s:trm_magenta s:trm_cyan s:trm_white
    unlet! s:gui_lightbrown s:gui_bluegreen s:gui_skyblue s:gui_purple
    unlet! s:trm_lightbrown s:trm_bluegreen s:trm_skyblue s:trm_purple

    delfunction s:tohex
    delfunction s:extractRGB
    delfunction s:guilevel
    delfunction s:trmlevel
    delfunction s:guicolor
    delfunction s:trmcolor
    delfunction s:setcolor
    delfunction s:hi
    delfunction s:set_brightness
    " }}}1
endtry
