syntax on
set ttyfast


" General
set number	        " Show line numbers
set showbreak=+++	" Wrap-broken line prefix
set textwidth=100	" Line wrap (number of cols)
set showmatch	        " Highlight matching brace
set visualbell	        " Use visual bell (no beeping)
 
set hlsearch	        " Highlight all search results
set smartcase	        " Enable smart-case search
set ignorecase	        " Always case-insensitive
set incsearch	        " Searches for strings incrementally
 
set autoindent	        " Auto-indent new lines
set expandtab	        " Use spaces instead of tabs
set shiftwidth=4	" Number of auto-indent spaces
set smartindent	        " Enable smart-indent
set smarttab	        " Enable smart-tabs
set softtabstop=4	" Number of spaces per Tab
 
" Advanced
set ruler	        " Show row and column ruler information
 
set undolevels=1000	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour

" powerline
" added as arch package as described in
" https://wiki.archlinux.org/index.php/Powerline#Vim
let g:powerline_pycmd="py3"
set laststatus=2

