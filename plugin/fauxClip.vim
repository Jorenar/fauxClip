" fauxClip - Clipboard support without +clipboard
" Author:  Jorenar <dev@jorenar.com>

if exists("g:loaded_fauxClip") | finish | endif
let s:cpo_save = &cpo | set cpo&vim

let s:regcmds = get(g:, "fauxClip_regcmds", {})

function! s:set(reg, action, cmd) abort
  if has_key(s:regcmds, a:reg)
    if has_key(s:regcmds[a:reg], a:action)
      return
    endif
  else
    let s:regcmds[a:reg] = {}
  endif
  let s:regcmds[a:reg][a:action] = a:cmd
endfunction

if !has("clipboard") ||
      \ get(g:, "fauxClip_sys_force", get(g:, "fauxClip_always_use", 0))
  if exists("g:fauxClip_copy_cmd")
    call s:set("+", "yank", g:fauxClip_copy_cmd)
  endif
  if exists("g:fauxClip_paste_cmd")
    call s:set("+", "paste", g:fauxClip_paste_cmd)
  endif
  if exists("g:fauxClip_copy_primary_cmd")
    call s:set("*", "yank", g:fauxClip_copy_primary_cmd)
  endif
  if exists("g:fauxClip_paste_primary_cmd")
    call s:set("*", "paste", g:fauxClip_paste_primary_cmd)
  endif

  if executable("wl-copy") && !empty($WAYLAND_DISPLAY) &&
        \ (!empty(glob($XDG_RUNTIME_DIR.'/'.$WAYLAND_DISPLAY))
        \  || !empty(glob($WAYLAND_DISPLAY)))
    call s:set("+", "yank", "wl-copy")
    call s:set("*", "yank", "wl-copy --primary")
    call s:set("+", "paste", "wl-paste --no-newline")
    call s:set("*", "paste", "wl-paste --primary --no-newline")
  elseif executable("xclip") && !empty($DISPLAY)
    call s:set("+", "yank",  "xclip -f -i -selection clipboard")
    call s:set("+", "paste", "xclip -o -selection clipboard")
    call s:set("*", "yank",  "xclip -f -i")
    call s:set("*", "paste", "xclip -o")
  elseif executable("xsel") && !empty($DISPLAY)
    call s:set("+", "yank",  "xsel -i -b")
    call s:set("+", "paste", "xsel -o -b")
    call s:set("*", "yank",  "xsel -i")
    call s:set("*", "paste", "xsel -o")
  elseif executable("clip.exe")
    call s:set("+", "yank",  "clip.exe")
    call s:set("+", "paste", "powershell.exe Get-Clipboard")
  elseif executable("pbcopy")
    call s:set("+", "yank",  "pbcopy")
    call s:set("+", "paste", "pbpaste")
  endif

  if $WSL2_GUI_APPS_ENABLED
    silent! unlet s:regcmds["*"]
  endif

  if !empty(get(s:regcmds, "+", {}))
    call s:set("*", "yank",  s:regcmds["+"]["yank"])
    call s:set("*", "paste", s:regcmds["+"]["paste"])
  endif
endif

let g:fauxClip_tmux_reg = get(g:, "fauxClip_tmux_reg", ']')
if !empty(g:fauxClip_tmux_reg) && !empty($TMUX)
  call s:set(g:fauxClip_tmux_reg, "yank",  "tmux load-buffer -")
  call s:set(g:fauxClip_tmux_reg, "paste", "tmux save-buffer -")
endif


if empty(s:regcmds) | finish | endif


if get(g:, "fauxClip_suppress_errors", 1)
  let s:null = (executable("clip.exe") && !has("unix")) ? " 2> NUL" : " 2> /dev/null"
  for r in keys(s:regcmds)
    if has_key(s:regcmds[r], "yank")
      let s:regcmds[r]["yank"]  .= s:null
    endif
    if has_key(s:regcmds[r], "paste")
      let s:regcmds[r]["paste"] .= s:null
    endif
  endfor | unlet r s:null
endif

if get(g:, "fauxClip_crlf2lf", (has("unix") && executable("sed")))
  for r in keys(s:regcmds)
    if has_key(s:regcmds[r], "paste")
      let s:regcmds[r]["paste"] .= " | sed 's/\\r$//g'"
    endif
  endfor | unlet r
endif


function! s:start(REG) abort
  let s:REG = a:REG
  let s:reg = [getreg('"'), getregtype('"')]

  let @@ = s:paste(s:REG)

  augroup fauxClip
    autocmd!
    if exists('##TextYankPost')
      autocmd TextYankPost * if v:event.regname == '"' | call s:yank(v:event.regcontents) | endif
    else
      autocmd CursorMoved  * if @@ != s:reg | call s:yank(@@) | endif
    endif
    autocmd TextChanged  * call s:end()
  augroup END

  return '""'
endfunction

function! s:end() abort
  augroup fauxClip
    autocmd!
  augroup END
  call setreg('"', s:reg[0], s:reg[1])
  unlet! s:reg s:REG
  redraw
endfunction

function! s:yank(content) abort
  if has_key(s:regcmds[s:REG], "yank")
    call system(s:regcmds[s:REG]["yank"], a:content)
  endif
  call s:end()
endfunction

function! s:paste(REG) abort
  if has_key(s:regcmds[a:REG], "paste")
    return system(s:regcmds[a:REG]["paste"])
  endif
endfunction

for r in keys(s:regcmds)
  exec 'nnoremap <expr> "'.r '<SID>start("'.r.'")'
  exec 'vnoremap <expr> "'.r '<SID>start("'.r.'")'

  exec 'noremap! <C-r>'.r       '<C-r>=<SID>paste("'.r.'")<CR>'
  exec 'noremap! <C-r><C-r>'.r  '<C-r><C-r>=<SID>paste("'.r.'")<CR>'
  exec 'noremap! <C-r><C-o>'.r  '<C-r><C-o>=<SID>paste("'.r.'")<CR>'
  exec 'inoremap <C-r><C-p>'.r  '<C-r><C-p>=<SID>paste("'.r.'")<CR>'
endfor | unlet r


function! s:cli(cmd, REG) abort range
  let s:REG = a:REG
  let s:reg = [getreg('"'), getregtype('"')]
  if a:cmd =~# 'pu\%[t]'
    execute a:firstline . ',' . a:lastline . a:cmd ."=s:paste(s:REG)"
    call s:end()
  else
    execute a:firstline . ',' . a:lastline . a:cmd
    call s:yank(getreg('"'))
  endif
endfunction

function! s:cli_set_CR() abort
  if !exists("s:CR_old") | let s:CR_old = maparg('<CR>', 'c', '', 1) | endif
  cnoremap <expr> <silent> <CR> <SID>cli_check() ? '<C-u>'.<SID>cli_CR().'<CR>' : '<CR>'
endfunction

function! s:cli_restore_CR() abort
  if empty(s:CR_old)
    cunmap <CR>
  else
    execute   (s:CR_old["noremap"] ? "cnoremap " : "cmap ")
          \ . (s:CR_old["silent"]  ? "<silent> " : "")
          \ . (s:CR_old["nowait"]  ? "<nowait> " : "")
          \ . (s:CR_old["expr"]    ? "<expr> "   : "")
          \ . (s:CR_old["buffer"]  ? "<buffer> " : "")
          \ . s:CR_old["lhs"]." ".s:CR_old["rhs"]
  endif
  unlet s:CR_old
endfunction

let s:cli_pattern =
      \ '\v%(%(^|\|)\s*%(\%|\d\,\d|' . "'\\<\\,'\\>" . ')?\s*)@<='
      \ . '(y%[ank]|d%[elete]|pu%[t]!?)\s*(['
      \   . escape(join(keys(s:regcmds), ''), ']^-\')
      \ . '])'

function! s:cli_CR() abort
  call s:cli_restore_CR()
  call histadd(":", getcmdline())
  let sid = matchstr(expand("<sfile>"), '<SNR>\d\+_')
  return substitute(getcmdline(),
        \ s:cli_pattern,
        \ 'call '.sid.'cli(''\1'', ''\2'')', 'g')
        \ . " | call histdel(':', -1)"
endfunction

function! s:cli_check() abort
  return getcmdline() =~# s:cli_pattern
endfunction

augroup fauxClip_CliWrapper
  autocmd!
  autocmd CmdlineChanged :
        \  if <SID>cli_check()
        \|   call <SID>cli_set_CR()
        \| elseif exists('<SID>CR_old')
        \|   call <SID>cli_restore_CR()
        \| endif
augroup END

let g:loaded_fauxClip = 1
let &cpo = s:cpo_save | unlet s:cpo_save
