# dotfiles

Structure:
```
├── bin
│   └── emailinfo
├── config
│   └── vis
└── home
    ├── .bash_completions
    ├── .bash_logout
    ├── .bash_paths
    ├── .bash_profile
    ├── .bashrc
    ├── .exrc
    ├── .gitconfig
    ├── .gitconfig
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
