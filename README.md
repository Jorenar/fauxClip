fauxClip
========

**DEPRECATION NOTICE**

This plugin is deprecated in favour of native clipboard providers:
* [`clipboard-providers`](https://vimhelp.org/eval.txt.html#clipboard-providers) in [Vim 9.1.1972](https://github.com/vim/vim/commit/fcd3958dc)
* [`provider-clipboard`](https://neovim.io/doc/user/provider/#provider-clipboard) in Neovim

---

**fauxClip** is a Vim plugin allowing defining custom registers, with primary
goal of providing a pseudo _clipboard_ support for versions of Vim compiled
without _+clipboard_.

---

Default utilities for clipboard yank and paste are:

* `wl-copy` + `wl-paste` (on Linux with Wayland, or WSL2)
* `xclip`  (on Linux with X server, or WSL2)
* `xsel`   (fallback to `xclip`)
* `pbcopy` + `pbpaste` (on macOS)
* `clip.exe` + `powershell.exe Get-Clipboard` (on Windows)

---

Assuming you are on Linux, using tmux, `xclip` is installed, and you didn't
change any of fauxClip's defaults, then the dictionary with commands for
registers will be set as following:

```vim
let g:fauxClip_regcmds = {
      \   '+': {
      \     'yank':  'xclip -f -i -selection clipboard',
      \     'paste': 'xclip -o -selection clipboard',
      \   },
      \   '*': {
      \     'yank':  'xclip -f -i',
      \     'paste': 'xclip -o',
      \   },
      \   ']': {
      \     'yank':  'tmux load-buffer -',
      \     'paste': 'tmux save-buffer -',
      \   }
      \ }
```

By manually setting any of the items you can overwrite the defaults, or craft
your own registers:
```vim
let g:fauxClip_regcmds = {
      \   '!': {
      \     'paste': 'echo "Bang!"'
      \   }
      \ }
```

**Note:** to disable clipboard registers `*` and `+` you need to explicitly set
them to empty strings.

---

To set different "register" for tmux than `]`:
```vim
let g:fauxClip_tmux_reg = 't'
```

If for some reason you don't want to suppress error messages from clipboard
command (e.g. `xclip`'s empty clipboard), then:
```vim
let g:fauxClip_suppress_errors = 0
```

If Vim is compiled with +clipboard, but you want to force usage of custom
commands for system clipboard regardless, then:
```vim
let g:fauxClip_sys_force = 1
```

To disable removal of carriage return on Windows/WSL2 when pasting, set:
```vim
let g:fauxClip_crlf2lf = 0
```
