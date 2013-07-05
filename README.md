winresizer.vim
================

very simple vim plugin for easy resizing of your vim windows

## In default setting

1. You press keys `Ctrl + E` or execute `:WinResizerStartResize` on vim(in normal mode), to run this plugin

2. Start 'window resize mode', and you can resize current vim windows using 'h', 'j', 'k', 'l' keys

3. You want to finish resize mode, then press "Enter" key

4. If you cancel window resize, then press "q" key.
   You will get window size of before change

## Customize options

If you change setting and key mapping, can use below option.

|variable name|default key|description|
|:-----------|:---------:|:----------|
|g:winresizer_enable|1|Use winresizer (If this value is 0, this plugin will not work)|
|g:winresizer_finish_with_escape|1|If this value is 1, window resize mode is finished(fixed) by `Esc`|
|g:winresizer_vert_resize|10|The change width of window size when `left` or `right` key is pressed|
|g:winresizer_horiz_resize|3|The change height of window size when `down` or `up` key is pressed|
|g:winresizer_start_key|`Ctrl + e`|Start window resize mode|
|g:winresizer_keycode_left|104(`h`)|Expand window size to left|
|g:winresizer_keycode_right|108(`l`)|Expand window size to right|
|g:winresizer_keycode_down|106(`j`)|Expand window size to down|
|g:winresizer_keycode_up|107(`k`)|Expand window size to up|
|g:winresizer_keycode_finish|13(`Enter`)|Fix and escape from window resize mode|
|g:winresizer_keycode_cancel|113(`q`)|Cancel and quit window resize mode|

#### _Example in your .vimrc_

    " If you want to start window resize mode by `Ctrl+T`
    let g:winresizer_start_key = '<C-T>'
    
    " If you cancel and quit window resize mode by `z` (keycode 122)
    let g:winresizer_keycode_cancel = 122

## License

winresizer is released under the MIT license.

The MIT License (MIT)

Copyright (c) 2012 jimsei

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
