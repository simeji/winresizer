" FILE: winresizer.vim: vim plugin for easy resizing of your vim windows 
" AUTHOR:	jimsei <twitter: @jimsei_jp> <gmail: jimsei.jp@gmail.com >
" Date:		Nov 5, 2011
" License: MIT license  
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
"
" =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
"
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
let g:winresizer_start_key = get(g:, 'winresizer_start_key', s:default_start_key)
let g:winresizer_enable    = get(g:, 'winresizer_enable',    1)

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
             \           'escape':'27'
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


exec 'nnoremap ' . g:winresizer_start_key .' :WinResizerStartResize<CR>'

com! WinResizerStartResize call WinResizerStartResize()

fun! WinResizerStartResize()

  if g:winresizer_enable == 0
    return
  endif


  let l:codeList = {
        \           'left' : g:winresizer_keycode_left, 
        \           'down' : g:winresizer_keycode_down, 
        \           'up'   : g:winresizer_keycode_up,
        \           'right': g:winresizer_keycode_right 
        \          }

  let l:behavior = s:getResizeBehavior(l:codeList)

  let l:left_resize  = l:behavior[l:codeList['left']]  . g:winresizer_vert_resize
  let l:right_resize = l:behavior[l:codeList['right']] . g:winresizer_vert_resize
  let l:up_resize    = l:behavior[l:codeList['up']]    . g:winresizer_horiz_resize
  let l:down_resize  = l:behavior[l:codeList['down']]  . g:winresizer_horiz_resize

  let l:rest = winrestcmd()

  while 1

    echo '[window resize mode]... "Enter": OK , "q": Cancel'
    let l:c = getchar()

    if l:c == l:codeList['left'] "h
      exec ':vertical resize '.l:left_resize
    elseif l:c == l:codeList['down'] "j
      exec ':resize '.l:down_resize
    elseif l:c == l:codeList['up'] "k
      exec ':resize '.l:up_resize
    elseif l:c == l:codeList['right'] "l
      exec ':vertical resize '.l:right_resize
    elseif l:c == g:winresizer_keycode_cancel "q
      exec l:rest
      exec ":redraw"
      echo "Canceled!"
      break
    elseif l:c == g:winresizer_keycode_finish || (g:winresizer_finish_with_escape == 1 && l:c == g:winresizer_keycode_escape)
      exec ":redraw"
      echo "Finished!"
      break
    endif
    exec ":redraw"
  endwhile
endfun

" Decide behavior of up, down, left and right key .
" (to increase or decrease window size) 
fun! s:getResizeBehavior(codeList)
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
  for direct in keys(a:codeList)
    exec 'let result["' .a:codeList[direct]. '"] = "' . signs[direct] . '"' 
  endfor
  return result
endfun

" Get opposite sign about + and -
fun! s:getOppositeSign(sign)
  let sign = '+'
  if a:sign == '+'
    let sign = '-'
  endif
  return sign
endfun


let &cpo = s:save_cpo
