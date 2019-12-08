" fauxClip - Clipboard support without +clipboard
" Maintainer:  Jorengarenar <https://joren.ga>

function! fauxClip#start(REG)
    let s:REG = a:REG
    let s:reg = getreg('"')
    let s:regtype = getregtype('"')

    let @@ = fauxClip#paste(s:REG)

    augroup fauxClip
        autocmd!
        if exists('##TextYankPost')
              autocmd TextYankPost * if v:event.regname == '"' | call fauxClip#yank(v:event.regcontents, s:REG) | endif
          else
              autocmd CursorMoved  * if @@ != s:reg | call fauxClip#yank(@@, s:REG) | endif
        endif
        autocmd TextChanged  * call fauxClip#end()
    augroup END

    return '""'
endfunction

function! fauxClip#yank(content, REG)
    if a:REG == "+"
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
    call setreg('"', s:reg, s:regtype)
    unlet! s:reg s:regtype s:REG
endfunction

function! fauxClip#cmd(cmd, reg) range
    let range = a:firstline . ',' . a:lastline
    call fauxClip#start(a:reg)
    execute range . a:cmd
endfunction

function! fauxClip#cmd_wrapper()
    let cmd = substitute(getcmdline(), '\<\(y\%[ank]\|d\%[elete]\|p\%[ut]!\?\)\s*\([+*]\)', 'call fauxClip#cmd(''\1'', ''\2'')', 'g')
    execute cmd
endfunction
