" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

if &cp || has("clipboard") || exists('g:loaded_fauxClip') || !exists('##TextYankPost') || !exists('##TextChanged') || !exists('##CmdlineLeave')
    finish
endif

if !exists('g:fauxClip_copy_cmd')
    let g:fauxClip_copy_cmd = 'xclip -f -i -selection clipboard'
endif

if !exists('g:fauxClip_paste_cmd')
    let g:fauxClip_paste_cmd = 'xclip -o -selection clipboard 2> /dev/null'
endif

if !exists('g:fauxClip_copy_primary_cmd')
    let g:fauxClip_copy_primary_cmd = 'xclip -f -i'
endif

if !exists('g:fauxClip_paste_primary_cmd')
    let g:fauxClip_paste_primary_cmd = 'xclip -o 2> /dev/null'
endif

augroup fauxClipCmdWrapper
  autocmd!
  autocmd CmdlineLeave : if getcmdline() =~ "[dy].*[+*]" | call fauxClip#cmd_wrapper() | endif
augroup END

nnoremap <expr> "* fauxClip#start("*")
nnoremap <expr> "+ fauxClip#start("+")

vnoremap <expr> "* fauxClip#start("*")
vnoremap <expr> "+ fauxClip#start("+")

noremap! <C-r>+       <C-r>=fauxClip#paste("+")<CR>
noremap! <C-r><C-r>+  <C-r><C-r>=fauxClip#paste("+")<CR>
noremap! <C-r><C-o>+  <C-r><C-o>=fauxClip#paste("+")<CR>
inoremap <C-r><C-p>+  <C-r><C-p>=fauxClip#paste("+")<CR>

noremap! <C-r>*       <C-r>=fauxClip#paste("*")<CR>
noremap! <C-r><C-r>*  <C-r><C-r>=fauxClip#paste("*")<CR>
noremap! <C-r><C-o>*  <C-r><C-o>=fauxClip#paste("*")<CR>
inoremap <C-r><C-p>*  <C-r><C-p>=fauxClip#paste("*")<CR>

let g:loaded_fauxClip = 1

" vim: fdm=marker fen
