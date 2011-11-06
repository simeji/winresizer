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

if exists('g:loaded_autoload_winresizer') 
  finish
endif

let g:loaded_autoload_winresizer = 1

let s:save_cpo = &cpo
set cpo&vim

" when value is 1 in return dictionary, 
" current window has edge in direction of dictionary key name
fun! winresizer#getEdgeInfo()
  let chk_direct = ['left', 'down', 'up', 'right']
  let result = {}
  for direct in chk_direct
    exec 'let result["' . direct . '"] = ' . !winresizer#canMoveCursorFromCurrentWindow(direct)
  endfor
  return result
endfun

fun! winresizer#canMoveCursorFromCurrentWindow(direct)
  let map_direct = {'left':'h', 'down':'j', 'up':'k', 'right':'l'}
  if has_key(map_direct, a:direct)
    let direct = map_direct[a:direct]
  elseif index(values(map_direct), a:direct) != -1
    let direct = a:direct
  endif
  let from = winnr()
  exe "wincmd " . direct
  let to = winnr()
  exe from . "wincmd w"
  return from != to
endfun

let &cpo = s:save_cpo
