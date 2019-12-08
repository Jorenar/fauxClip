" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

" Init, variables {{{1

if has("clipboard")
    finish
endif

if exists('g:loaded_fauxClip')
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

" Mappings {{{1

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

cnoremap <expr> <CR> getcmdtype() == ':' && getcmdline() =~ "[dy].*[+*]" ? '<C-u>'.fauxClip#CR().'<CR>' : '<CR>'

" End "{{{1
let g:loaded_fauxClip = 1
" vim: fdm=marker fen
