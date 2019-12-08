" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

if &cp || has("clipboard") || exists('g:loaded_fauxClip') || !exists('##TextChanged') || !exists('##CmdlineLeave')
    finish
endif

if !exists('g:fauxClip_copy_cmd')
    if executable('pbcopy')
        let g:fauxClip_copy_cmd = 'pbcopy'
    else
        let g:fauxClip_copy_cmd = 'xclip -f -i -selection clipboard'
    endif
endif

if !exists('g:fauxClip_paste_cmd')
    if executable('pbcopy')
        let g:fauxClip_paste_cmd = 'pbpaste'
    else
        let g:fauxClip_paste_cmd = 'xclip -o -selection clipboard 2> /dev/null'
    endif
endif

if !exists('g:fauxClip_copy_primary_cmd')
    if executable('pbcopy')
        let g:fauxClip_copy_primary_cmd = 'pbcopy'
    else
        let g:fauxClip_copy_primary_cmd = 'xclip -f -i'
    endif
endif

if !exists('g:fauxClip_paste_primary_cmd')
    if executable('pbcopy')
        let g:fauxClip_paste_primary_cmd = 'pbpaste'
    else
        let g:fauxClip_paste_primary_cmd = 'xclip -o 2> /dev/null'
    endif
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
