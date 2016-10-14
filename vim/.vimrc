syntax on
set nu
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set autoindent
set cursorline
set history=100
set expandtab
set shiftround
set hlsearch
set nocompatible " be iMproved
set laststatus=2   " Always show the statusline
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors
set runtimepath^=~/.vim/bundle/ctrlp.vim
set background=dark
filetype on
filetype indent on
filetype plugin on

"Fzf configuration
set rtp+=~/.fzf

filetype off

call plug#begin('~/.vim/plugged')

Plug 'powerline/powerline'
Plug 'powerline/fonts' 
Plug 'othree/html5.vim'
Plug 'scrooloose/syntastic'
"less highlighter
au BufRead,BufNewFile *.less setfiletype css
"markdown highlighter
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" vim-scripts repos

filetype plugin indent on " required!

"ruby support for vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-ruby/vim-ruby'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-rails'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}  
Plug 'junegunn/seoul256.vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'kana/vim-textobj-user'
set nocompatible
if has("autocmd")
  filetype indent plugin on
endif
Plug 'tpope/vim-vinegar'

"DB support
Plug 'ivalkeen/vim-simpledb'

call plug#end()

let g:seoul256_background = 235
colo seoul256

"Tab for completion
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
:inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
:set dictionary="/usr/dict/words"

"highlight long lines
match Error /\%81v.\+/

" ------- external stuff -------
set wildmode=list:full,full
set wildignorecase
set ignorecase
set smartcase
set complete=.,w,b,u,t,i
set lazyredraw
map              é     /
noremap <silent> É     :nohlsearch<cr><c-l>
map              è     :
map              à     :q<cr>
map              È     :!
map              @     :tabnext<cr>
map              §     :tabnext<cr>
map              <F1>  :Files<cr>
map              <F2>  :tab<Space>new<cr>
noremap <silent> <F4>  :nohlsearch<cr><c-l>
map     <silent> <F5>  :%s/:\([a-zA-Z_]*\)<Space>\+=>/\1:/gc<cr>
map     <silent> <F6>  :%s/\(\S\+\)<Space><Space>\+\(\S\)/\1<Space>\2/gc<cr>
map              <F10> :e<Space>~/Code/sandbox.sql<cr>
map              <F12> :e<Space>~/.config/nvim/init.vim<cr> 
set timeoutlen=500 ttimeoutlen=0
set grepprg=ag

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
