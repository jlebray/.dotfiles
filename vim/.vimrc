"Vimrc Johan Le Bray


" ===== SETTINGS =====

syntax on
set nu
set nocompatible
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
set relativenumber
set laststatus=2
set runtimepath^=~/.vim/bundle/ctrlp.vim
set background=dark
set ruler
set splitbelow
set splitright
set hidden
set scrolloff=10
set visualbell
set spelllang=fr
set wildmode=list:full,full
set wildignorecase
set ignorecase
set smartcase
set complete=.,w,b,u,t,i
set lazyredraw
set timeoutlen=500 ttimeoutlen=0
set thesaurus+=~/.vim/francais_vim.txt
set rtp+=/usr/local/opt/fzf
set dictionary="/usr/dict/words"
if (has("termguicolors"))
  set termguicolors
endif
if exists('&inccommand')
  set inccommand=split
endif

highlight ExtraWhitespace guibg=#990000 ctermbg=red
highlight TermCursor ctermfg=red guifg=red

autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

autocmd BufRead,BufNewFile *.{arb} set filetype=ruby
autocmd BufRead,BufNewFile *.{txt,tex} set spell breakindent linebreak
autocmd BufRead,BufNewFile *.scss.css setfiletype scss
autocmd BufRead,BufNewFile *.less setfiletype css

"Dynamically replace
"powerline fonts
let g:airline_powerline_fonts = 1
let g:airline_theme='papercolor'

"The silver searcher
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

"Delete non empty directories with netrw
let g:netrw_localrmdir='rm -r'

"Always colorize
let g:colorizer_nomap = 1

"install vim-plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif


" ===== GET PLUGINS =====

call plug#begin('~/.vim/plugged')

"File management
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'

"tools
Plug 'tpope/vim-repeat'                "Better repeat
Plug 'tpope/vim-surround'              "surround verb
Plug 'tpope/vim-commentary'            "Easy comment
Plug 'sbdchd/vim-run'                  "Run scripts
Plug 'junegunn/vim-peekaboo'           "look at registers
Plug 'kana/vim-textobj-user'           "custom blocks
Plug 'Chiel92/vim-autoformat'          "fast formatting
Plug 'bronson/vim-trailing-whitespace' "remove whitespaces
Plug 'jlebray/splitjoin.vim'           "Line splitting
Plug 'vim-scripts/colorizer'           "RGB colors
Plug 'Valloric/YouCompleteMe'          "Fuzzy completion

"errors
Plug 'scrooloose/syntastic'

"Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

"HTML
Plug 'othree/html5.vim'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

"Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'thoughtbot/vim-rspec'
Plug 'nelstrom/vim-textobj-rubyblock'

"Coffee
Plug 'kchmck/vim-coffee-script'

"Crystal
Plug 'rhysd/vim-crystal'

"Markdown
Plug 'plasticboy/vim-markdown'

"DB
Plug 'ivalkeen/vim-simpledb'

"Writing
Plug 'dbmrq/vim-ditto'
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'

"Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/seoul256.vim'
Plug 'colepeters/spacemacs-theme.vim'
Plug 'NLKNguyen/papercolor-theme'

call plug#end()


" ===== APPLY THEME =====

"let g:seoul256_background = 235
"colorscheme seoul256
colorscheme spacemacs-theme
"colorscheme PaperColor


" ===== MAPPINGS =====

"Leader = Spacebar
let mapleader = " "

"switch ; and :
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

"Move between visual lines BUT keep correct count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

"tabs
nnoremap K     :tabnext<cr>
nnoremap J     :tabprev<cr>
nnoremap <c-n> J

"splits
nnoremap <Leader>j :split<cr>
nnoremap <Leader>k :split<cr><c-w>k
nnoremap <Leader>l :vsplit<cr>
nnoremap <Leader>h :vsplit<c-w>h

"Open previous file
nnoremap <tab> <C-^>

"Save
nnoremap <Leader>s :w<cr>

"Run current file
nnoremap <leader>e :Run<cr>

"Copy to clipboard
vnoremap <leader>y "+y

"jump between errors
let g:syntastic_always_populate_loc_list = 1
nnoremap [e :lprev<cr>
nnoremap ]e :lnext<cr>

"Fuzzy finder configuration
let g:fzf_files_options = '--preview "(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'"'
nnoremap              <F1>  :Files<cr>
nnoremap              <F2>  :tab<Space>new<cr>

"Remove search highlighting
nnoremap <silent>     <F4>  :nohlsearch<cr><c-l>
nnoremap         *     *<c-o>

"Rspec
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>

"Tags
nnoremap <F5> :ts<Space>

"Formating
nnoremap <F3> :Autoformat<CR>
nnoremap <Leader>w :FixWhitespace<CR>

"Mac only
nnoremap § :q<cr>
nnoremap ± :qa!<cr>

"Move between splits
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

"Open file in new tab
function! OpenCurrentAsNewTab()
  let l:currentPos = getcurpos()
  tabedit %
  call setpos(".", l:currentPos)
endfunction
nmap <Leader>[ :call OpenCurrentAsNewTab()<CR>

"Format JSON
function! FormatJSON()
  %!python -m json.tool
endfunction
command! FormatJSON call FormatJSON()

"tab for completion
" function! Tab_Or_Complete()
"   if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
"     return "\<C-N>"
"   else
"     return "\<Tab>"
"   endif
" endfunction
" inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
