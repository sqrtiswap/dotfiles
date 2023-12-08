" display current mode (insert/normal)
set showmode

" show matching parens, braces, etc
set showmatch

" display row/column info
set ruler

" autoindent width = 2 spaces
set autoindent
set shiftwidth=2

" tab width = 2 spaces
set tabstop=8

" display all error messages
"set verbose

" case-insensitive search, unless an uppercase letter is used
set ignorecase
set smartcase
"set iclower

" incremental search
"set searchincr

" print helpful messages (eg, 4 lines yanked)
set report=1

"set cedit=\
"set filec=\
set number
set relativenumber
"set wraplen=72

map gS {j!}sort -ur
map gT :%!a=$(cat %);echo "$a"
map gY !'mtmux load-buffer -u
map ga :E %_test
map gd :r!date +\%Y-\%m-\%d
map ge :E
map gg 1G
map go :%!gofmt
map gp :r!xclip -o -selection clipboard
map gs {!}sort -u
map gt mM:%s/[[:space:]]*$//
