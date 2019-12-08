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

function! fauxClip#cmd_wrapper()
    command! -bar -range -nargs=1 FauxClipY execute "<line1>,<line2>!".expand('<args>' == '*' ? g:fauxClip_copy_primary_cmd : g:fauxClip_copy_cmd)
    command! -bar -range -nargs=1 FauxClipD execute "<line1>,<line2>!".expand('<args>' == '*' ? g:fauxClip_copy_primary_cmd : g:fauxClip_copy_cmd) | silent! execute "<line1>,<line2>d _"
    execute substitute(getcmdline(), '\(y\|ya\|yank\?\|d\|de\|del\|dele\|delete\?\)\s*\([+\*]\)', '\="FauxClip".toupper(submatch(1)[0])." ".submatch(2)', 'g')
    setlocal nomodifiable
    call timer_start(0, {-> execute("delc FauxClipY | delc FauxClipD | setlocal modifiable | redraw!")})
endfunction
