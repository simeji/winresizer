"---------------------------------------------------
" WinResizer 
"---------------------------------------------------
" This is simple plugin to resize window size 
" for someone using vim with split windows  
"
" ========================================
" start 'resize mode' key
" <C-E> or g:winresizer_start_key defined by .vimrc
"
" If you don't need this function,
" define global variable below in .vimrc
"
" let g:winresizer_enable
"
" keymap of [window resize mode]
" h : expand window size to left
" j : expand window size to down
" k : expand window size to up
" l : expand window size to right
" q : cancel resize window and escepe [window resize mode]
" Enter : fix and escape 

if exists("g:loaded_winresizer")
  finish
endif

let g:loaded_winresizer = 1

let s:save_cpo = &cpo
set cpo&vim

" default start resize window key mapping
let s:default_start_key = '<C-E>'

" If you define 'g:win_resizer_start_key' in .vimrc, 
" will be started resize window by 'g:win_resizer_start_key' 
let g:winresizer_start_key  = get(g:, 'winresizer_start_key', s:default_start_key)
let g:winresizer_enable     = get(g:, 'winresizer_enable', 1)

" for gui setting
let s:default_gui_start_key = '<C-A>'
let g:winresizer_gui_start_key = get(g:, 'winresizer_gui_start_key', s:default_gui_start_key)
let g:winresizer_gui_enable = get(g:, 'winresizer_gui_enable', 0)

let g:winresizer_vert_resize  = get(g:, 'winresizer_vert_resize', 10)
let g:winresizer_horiz_resize = get(g:, 'winresizer_horiz_resize', 3)

" resize mode key mapping
let s:default_keycode = {
             \           'left'  :'104',
             \           'down'  :'106',
             \           'up'    :'107',
             \           'right' :'108',
             \           'finish':'13',
             \           'cancel':'113',
             \           'escape':'27',
             \          }

let g:winresizer_keycode_left  = get(g:, 'winresizer_keycode_left', s:default_keycode['left'])
let g:winresizer_keycode_down  = get(g:, 'winresizer_keycode_down',  s:default_keycode['down'])
let g:winresizer_keycode_up    = get(g:, 'winresizer_keycode_up',    s:default_keycode['up'])
let g:winresizer_keycode_right = get(g:, 'winresizer_keycode_right', s:default_keycode['right'])

let g:winresizer_keycode_finish = get(g:, 'winresizer_keycode_finish', s:default_keycode['finish'])
let g:winresizer_keycode_cancel = get(g:, 'winresizer_keycode_cancel', s:default_keycode['cancel'])
let g:winresizer_keycode_escape = get(g:, 'winresizer_keycode_escape', s:default_keycode['escape'])

" if <ESC> key downed, finish resize mode
let g:winresizer_finish_with_escape = get(g:, 'winresizer_finish_with_escape', 1)

let s:codeList = {
        \  'left' : g:winresizer_keycode_left,
        \  'down' : g:winresizer_keycode_down,
        \  'up'   : g:winresizer_keycode_up,
        \  'right': g:winresizer_keycode_right,
        \}

exe 'nnoremap ' . g:winresizer_start_key .' :WinResizerStartResize<CR>'

com! WinResizerStartResize call WinResizerStartResize()

if has("gui_running") && g:winresizer_gui_enable != 0
  exe 'nnoremap ' . g:winresizer_gui_start_key .' :WinResizerStartResizeGUI<CR>'
  com! WinResizerStartResizeGUI call WinResizerStartResizeGUI()
endif

fun! WinResizerStartResizeGUI()
  if g:winresizer_enable == 0
    return
  endif
  let commands = {
      \  'left'   : 'let &columns = &columns - ' . g:winresizer_vert_resize,
      \  'right'  : 'let &columns = &columns + ' . g:winresizer_vert_resize,
      \  'up'     : 'let &lines = &lines - ' . g:winresizer_horiz_resize,
      \  'down'   : 'let &lines = &lines + ' . g:winresizer_horiz_resize,
      \  'cancel' : 'let &columns = ' . &columns . '|let &lines = ' . &lines . '|',
      \}
  call s:startReize(commands)

endfun

fun! WinResizerStartResize()
  if g:winresizer_enable == 0
    return
  endif

  let behavior = s:getResizeBehavior()

  let commands = {
        \  'left'   : ':vertical resize ' . behavior['left']  . g:winresizer_vert_resize,
        \  'right'  : ':vertical resize ' . behavior['right'] . g:winresizer_vert_resize,
        \  'up'     : ':resize ' . behavior['up']   . g:winresizer_horiz_resize,
        \  'down'   : ':resize ' . behavior['down'] . g:winresizer_horiz_resize,
        \  'cancel' : winrestcmd(),
        \}

  call s:startReize(commands)

endfun

fun! s:startReize(commands)

  while 1

    echo '[window resize mode]... "'.s:label_finish.'": OK , "'.s:label_cancel.'": Cancel'
    let c = getchar()

    if c == s:codeList['left'] "h
      exe a:commands['left']
    elseif c == s:codeList['down'] "j
      exe a:commands['down']
    elseif c == s:codeList['up'] "k
      exe a:commands['up']
    elseif c == s:codeList['right'] "l
      exe a:commands['right']
    elseif c == g:winresizer_keycode_cancel "q
      exe a:commands['cancel']
      redraw
      echo "Canceled!"
      break
    elseif c == g:winresizer_keycode_finish || (g:winresizer_finish_with_escape == 1 && c == g:winresizer_keycode_escape)
      redraw
      echo "Finished!"
      break
    endif
    redraw
  endwhile
endfun

" Decide behavior of up, down, left and right key .
" (to increase or decrease window size) 
fun! s:getResizeBehavior()
  let signs = {'left':'-', 'down':'+', 'up':'-', 'right':'+'}
  let result = {}
  let ei = winresizer#getEdgeInfo()
  if !ei['left'] && ei['right']
    let signs['left'] = '+'
    let signs['right'] = '-'
  endif
  if !ei['up'] && ei['down']
    let signs['up'] = '+'
    let signs['down'] = '-'
  endif
  return signs
endfun

" Get opposite sign about + and -
fun! s:getOppositeSign(sign)
  let sign = '+'
  if a:sign == '+'
    let sign = '-'
  endif
  return sign
endfun

fun! s:getKeyAlias(code)
  if a:code == 13
    let alias = "Enter"
  elseif a:code == 32
    let alias = "Space"
  else
    let alias = nr2char(a:code)
  end
  return alias
endfun

let s:label_finish = s:getKeyAlias(g:winresizer_keycode_finish)
let s:label_cancel = s:getKeyAlias(g:winresizer_keycode_cancel)


let &cpo = s:save_cpo
