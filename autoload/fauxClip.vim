" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

function! fauxClip#start(REG)
    let s:REG = a:REG
    let s:reg = [getreg('"'), getregtype('"')]

    let @@ = fauxClip#paste(s:REG)

    augroup fauxClip
        autocmd!
        if exists('##TextYankPost')
            autocmd TextYankPost * if v:event.regname == '"' | call fauxClip#yank(v:event.regcontents) | endif
        else
            autocmd CursorMoved  * if @@ != s:reg | call fauxClip#yank(@@) | endif
        endif
        autocmd TextChanged  * call fauxClip#end()
    augroup END

    return '""'
endfunction

function! fauxClip#yank(content)
    if s:REG == "+"
        call system(g:fauxClip_copy_cmd, a:content)
    else
        call system(g:fauxClip_copy_primary_cmd, a:content)
    endif

    call fauxClip#end()
endfunction

function! fauxClip#paste(REG)
    if a:REG == "+"
        return system(g:fauxClip_paste_cmd)
    else
        return system(g:fauxClip_paste_primary_cmd)
    endif
endfunction

function! fauxClip#end()
    augroup fauxClip
        autocmd!
    augroup END
    call setreg('"', s:reg[0], s:reg[1])
    unlet! s:reg s:REG
endfunction

function! fauxClip#cmd(cmd, REG) range
    let s:REG = a:REG
    let s:reg = [getreg('"'), getregtype('"')]
    execute a:firstline . ',' . a:lastline . a:cmd
    call fauxClip#yank(getreg('"'))
endfunction

function! fauxClip#cmd_wrapper()
    execute substitute(getcmdline(), '\<\(y\%[ank]\|d\%[elete]\|pu\%[t]!\?\)\s*\([+*]\)', 'call fauxClip#cmd(''\1'', ''\2'')', 'g')
    setlocal nomodifiable
    call timer_start(0, {-> execute("setlocal modifiable | redraw!")})
endfunction
