" Basic vim configuration as backup for when nvim isn't available

" Enable syntax highlighting
syntax on

" Enable file type detection
filetype plugin indent on

" Basic settings
set number              " Show line numbers
set relativenumber      " Show relative line numbers
set cursorline          " Highlight current line
set ruler               " Show cursor position
set showcmd             " Show incomplete commands
set showmatch           " Show matching brackets
set hlsearch            " Highlight search results
set incsearch           " Incremental search
set ignorecase          " Case insensitive search
set smartcase           " Case sensitive when uppercase is used
set autoindent          " Auto indent
set smartindent         " Smart indent
set expandtab           " Use spaces instead of tabs
set tabstop=4           " Tab width
set shiftwidth=4        " Indent width
set softtabstop=4       " Soft tab width
set backspace=indent,eol,start  " Better backspace behavior
set scrolloff=8         " Keep 8 lines visible when scrolling
set sidescrolloff=8     " Keep 8 columns visible when scrolling
set wrap                " Wrap long lines
set linebreak           " Break lines at word boundaries
set wildmenu            " Enhanced command completion
set wildmode=longest:full,full
set laststatus=2        " Always show status line
set encoding=utf-8      " UTF-8 encoding

" Disable arrow keys to encourage hjkl usage
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlighting with <leader>/
nnoremap <leader>/ :nohlsearch<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Toggle paste mode
set pastetoggle=<F2>

" Set colorscheme if available
silent! colorscheme desert

" Status line
set statusline=%f\ %m%r%h%w\ [%Y]\ [%{&ff}]\ %=%l,%c\ %p%%

" Don't create backup files
set nobackup
set nowritebackup
set noswapfile