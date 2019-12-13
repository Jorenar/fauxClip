" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

if has("clipboard") || exists('g:loaded_fauxClip') || !has('patch1206')
    finish
endif

let s:cpo_save = &cpo | set cpo&vim

let is_pbcopy = executable('pbcopy')

if !exists('g:fauxClip_copy_cmd')
    let g:fauxClip_copy_cmd = is_pbcopy ? 'pbcopy' : 'xclip -f -i -selection clipboard'
endif

if !exists('g:fauxClip_paste_cmd')
    let g:fauxClip_paste_cmd = is_pbcopy ? 'pbpaste' : 'xclip -o -selection clipboard 2> /dev/null'
endif

if !exists('g:fauxClip_copy_primary_cmd')
    let g:fauxClip_copy_primary_cmd = is_pbcopy ? 'pbcopy' : 'xclip -f -i'
endif

if !exists('g:fauxClip_paste_primary_cmd')
    let g:fauxClip_paste_primary_cmd = is_pbcopy ? 'pbpaste' : 'xclip -o 2> /dev/null'
endif

augroup fauxClipCmdWrapper
    autocmd!
    autocmd CmdlineChanged : if getcmdline() =~# '[dyp]\w*\s*[+*]'
                \| let g:CR_old = maparg('<CR>', 'c', '', 1)
                \| cnoremap <expr> <silent> <CR> getcmdline() =~# '[dyp]\w*\s*[+*]' ? '<C-u>'.fauxClip#CR().'<CR>' : '<CR>'
                \| elseif exists('g:CR_old') | call fauxClip#restore_CR() | endif
    autocmd CmdlineLeave : if exists('g:CR_old') | call fauxClip#restore_CR() | endif
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

let &cpo = s:cpo_save | unlet s:cpo_save

" vim: fdm=marker fen
