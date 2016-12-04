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
set ruler
set splitbelow
set splitright
highlight TermCursor ctermfg=red guifg=red
filetype on
filetype indent on
filetype plugin on
"Dynamically replace
if exists('&inccommand')
  set inccommand=split
endif

"Fzf configuration
set rtp+=~/.fzf

filetype off

"Note: install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

"Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif
if has('vim_starting')
  set nocompatible               " Be iMproved
  " Required:
  call plug#begin()
endif

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
Plug 'thoughtbot/vim-rspec'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}  
Plug 'junegunn/seoul256.vim'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'kana/vim-textobj-user'
set nocompatible
if has("autocmd")
  filetype indent plugin on
endif
Plug 'tpope/vim-vinegar'

"crystal support
Plug 'rhysd/vim-crystal'

"DB support
Plug 'ivalkeen/vim-simpledb'

"Silver search
Plug 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

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

"Replace highlighted text
function Replace(new)
  exe '%s//' . a:new . '/gc'
endfunction

" ------- external stuff -------
set wildmode=list:full,full
set wildignorecase
set ignorecase
set smartcase
set complete=.,w,b,u,t,i
set lazyredraw

"Bepo keyboard
map              é     /
noremap <silent> É     :nohlsearch<cr><c-l>
map              è     :
map              à     :q<cr>
map              È     :!

"tabs
map              K     :tabnext<cr>
map              J     :tabprev<cr>

"splits
nnoremap <Leader>j :split<cr>
nnoremap <Leader>k :split<cr><c-w>k
nnoremap <Leader>l :vsplit<cr>
nnoremap <Leader>h :vsplit<c-w>h

map              <F1>  :Files<cr>
map              <F2>  :tab<Space>new<cr>
noremap <silent> <F4>  :nohlsearch<cr><c-l>
nnoremap         *     *<c-o>
map              <c-X> :call Replace("")<left><left>
set timeoutlen=500 ttimeoutlen=0

"Rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>

"Mac only
map              §     :q<cr>
map              ±     :wq<cr>
map ® :%s/

"Dont you dare
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Workspace Setup
" ----------------
function! DefaultWorkspace()
  vnew
  wincmd h
  e term://zsh
  sp term://zsh
  sp term://zsh
  wincmd k
  wincmd k
endfunction
command! -register DefaultWorkspace call DefaultWorkspace()

au BufEnter * if &buftype == 'terminal' | :startinsert | endif

func! s:moveToSplit(direction)
  func! s:move(direction)
    stopinsert
    execute "wincmd" a:direction
  endfunc

  execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
        \ "<C-\\><C-n>"
        \ ":call <SID>move(\"" . a:direction . "\")<CR>"
  execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
          \ ":call <SID>move(\"" . a:direction . "\")<CR>"
endfunc

for dir in ["h", "j", "l", "k"]
  call s:moveToSplit(dir)
endfor

function! OpenCurrentAsNewTab()
    let l:currentPos = getcurpos()
    tabedit %
    call setpos(".", l:currentPos)
endfunction
function! CloseCurrentTab()
    let l:currentPos = getcurpos()
    tabclose %
    call setpos(".", l:currentPos)
endfunction
nmap <Leader>[ :call OpenCurrentAsNewTab()<CR>
nmap <Leader>] :call CloseCurrentTab()<CR>

