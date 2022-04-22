fauxClip
=============

**fauxClip** is a Vim plugin to provide a pseudo _clipboard_ support for
versions of Vim compiled without _+clipboard_

---

**fauxClip** uses

* `xclip` (or `xsel` as fallback)
* `pbcopy` / `pbpaste`
* `clip.exe` / `powershell.exe Get-Clipboard`
* `wl-copy` / `wl-paste`

as default copy and paste command, but you can
override either of these if you have more specific needs.

<sub>(The following examples utilize defaults for Linux)</sub>

* Copy:
``` vim
let g:fauxClip_copy_cmd         = 'xclip -f -i -selection clipboard'
let g:fauxClip_copy_primary_cmd = 'xclip -f -i'
```
* Paste:
``` vim
let g:fauxClip_paste_cmd         = 'xclip -o -selection clipboard'
let g:fauxClip_paste_primary_cmd = 'xclip -o'
```

---

If you for some reasons don't want to suppress error messages from clipboard
command (e.g. `xclip`'s empty clipboard), then:
```vim
let g:fauxClip_suppress_errors = 0
```

If Vim is compiled with _+clipboard_, but you want to use this plugin regardless, then:
```vim
let g:fauxClip_always_use = 1
```

## Installation

#### [minPlug](https://github.com/Jorengarenar/minPlug):
```vim
MinPlug Jorengarenar/fauxClip
```

#### [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'Jorengarenar/fauxClip'
```

#### Vim's packages
```bash
cd ~/.vim/pack/plugins/start
git clone git://github.com/Jorengarenar/fauxClip.git
```

#### Single file
```sh
curl --create-dirs -L https://raw.githubusercontent.com/Jorengarenar/fauxClip/master/plugin/fauxClip.vim -o ~/.vim/plugin/fauxClip.vim
```
