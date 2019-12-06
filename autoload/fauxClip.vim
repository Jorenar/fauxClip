" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

function! fauxClip#start(X_reg)
    let s:X_reg = a:X_reg
    let s:reg = getreg('"')

    let @@ = fauxClip#paste(s:X_reg)

    augroup fauxClip
        autocmd!
        autocmd TextYankPost * ++once if v:event.regname == '"' | call fauxClip#yank(v:event.regcontents, s:X_reg) | endif
        autocmd TextChanged  * ++once call fauxClip#end()
    augroup END

    return '""'
endfunction

function! fauxClip#yank(content, X_reg)
    if a:X_reg == "+"
        call system(g:fauxClip_copy_cmd, a:content)
    else
        call system(g:fauxClip_copy_primary_cmd, a:content)
    endif

    call fauxClip#end()
endfunction

function! fauxClip#paste(X_reg)
    if a:X_reg == "+"
        return system(g:fauxClip_paste_cmd)
    else
        return system(g:fauxClip_paste_primary_cmd)
    endif
endfunction

function! fauxClip#end()
    augroup fauxClip
        autocmd!
    augroup END
    call setreg('"', s:reg)
    unlet! s:reg s:X_reg
endfunction
