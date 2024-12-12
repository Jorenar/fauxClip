fauxClip
========

**fauxClip** is a Vim plugin allowing to define custom registers, with primary
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

Assuming you are on Linux, using Tmux, `xclip` is installed, and you didn't
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

To set different "register" for Tmux than `]`:
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

## Installation

#### [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'Jorenar/fauxClip'
```

#### Vim's packages
```bash
cd ~/.vim/pack/plugins/start
git clone git://github.com/Jorenar/fauxClip.git
```

#### Single file
```sh
curl --create-dirs -L https://raw.githubusercontent.com/Jorenar/fauxClip/master/plugin/fauxClip.vim -o ~/.vim/plugin/fauxClip.vim
```
