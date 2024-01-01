# dotfiles

Structure:
```
├── bin
│   ├── check_mutt_mailboxes
│   ├── emailinfo
│   ├── kbdlswitch
│   ├── mymail
│   ├── pass
│   ├── upgrade
│   └── vpn
├── config
│   ├── alacritty
│   │   └── alacritty.yml
│   ├── dunst
│   │   └── dunstrc
│   ├── hikari
│   │   ├── autostart
│   │   └── hikari.conf
│   ├── htop
│   │   └── htoprc
│   ├── mako
│   │   └── config
│   ├── mpDris2
│   │   └── mpDris2.conf
│   ├── mpd
│   │   └── mpd.conf
│   ├── mutt
│   │   ├── bindings.muttrc
│   │   ├── colours.muttrc
│   │   ├── global.muttrc
│   │   ├── macros.muttrc
│   │   ├── mailcap
│   │   ├── message-hooks.muttrc
│   │   ├── muttrc
│   │   └── scripts
│   │       ├── attachment_viewer
│   │       └── get_overview
│   ├── ncmpcpp
│   │   ├── bindings
│   │   └── config
│   ├── tkremindrc
│   ├── user-dirs.dirs
│   ├── user-dirs.locale
│   ├── vis
│   │   └── visrc.lua
│   ├── xfe
│   │   ├── xferc
│   │   ├── xfirc
│   │   └── xfwrc
│   ├── yt-dlp
│   │   └── config
│   └── zathura
│       └── zathurarc
└── home
    ├── .bash_completions
    ├── .bash_logout
    ├── .bash_paths
    ├── .bash_profile
    ├── .bashrc
    ├── .exrc
    ├── .gitconfig
    ├── .gitignore
    ├── .ksh_completions
    ├── .ksh_paths
    └── .kshrc
```

## Setup/Updating

Link config with
```shell
make link
```

Move scripts (and later update them) with
```shell
make
```

Do both with
```shell
make install
```

## Removal

Remove links with
```shell
make unlink
```

Remove scripts with
```shell
make remove
```

Do both with
```shell
make uninstall
```

## Licence
[ISC](https://opensource.org/licenses/ISC)
