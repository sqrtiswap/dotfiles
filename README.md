# dotfiles

Structure:
```
├── bin
│   ├── agenda
│   ├── barstarter
│   ├── check_mutt_mailboxes
│   ├── drawsep
│   ├── emailinfo
│   ├── kbdlswitch
│   ├── lemonscript.sh
│   ├── mymail
│   ├── pass
│   ├── see
│   ├── tellme
│   ├── termbar.sh
│   ├── upgrade
│   ├── videocall
│   ├── vpn
│   └── wallpapermaker
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
├── desktopfiles
│   ├── acme.desktop
│   ├── email.desktop
│   └── tkremind.desktop
├── home
│   ├── .bash_completions
│   ├── .bash_logout
│   ├── .bash_paths
│   ├── .bash_profile
│   ├── .bashrc
│   ├── .exrc
│   ├── .gitconfig
│   ├── .gitignore
│   ├── .ksh_completions
│   ├── .ksh_paths
│   └── .kshrc
└── xbar-plugins
    ├── mpd_control.10s.sh
    └── todo_today.1s.sh
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
