"Vimrc Johan Le Bray
" ===== SETTINGS =====

syntax on
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set softtabstop=2
set cursorline
set smarttab
set autoindent
set history=100
set expandtab
set shiftround
set hlsearch
set laststatus=2
set runtimepath^=~/.vim/bundle/ctrlp.vim
set title
set ruler
set splitbelow
set splitright
set hidden
set nobackup
set noswapfile
set scrolloff=10
set visualbell
set wildmode=list:full,full
set wildignorecase
set ignorecase
set smartcase
set complete=.,w,b,u,t,i
set lazyredraw
set timeoutlen=500 ttimeoutlen=0
set spelllang=fr
set thesaurus+=~/.vim/francais_vim.txt
set rtp+=/usr/local/opt/fzf
set dictionary="/usr/dict/words"
if (has("termguicolors"))
  set termguicolors
endif
if exists('&inccommand')
  set inccommand=split
endif


autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif

autocmd BufRead,BufNewFile *.{arb} set filetype=ruby
autocmd BufRead,BufNewFile *.{txt,tex} set spell breakindent linebreak
autocmd BufRead,BufNewFile *.scss.css setfiletype scss
autocmd BufRead,BufNewFile *.less setfiletype css

let g:airline_powerline_fonts = 1    "powerline fonts
let g:airline_theme='base16_spacemacs'     "powerline fonts
if executable('ag')
  let g:ackprg = 'ag --vimgrep'      "The silver searcher
endif
let g:netrw_localrmdir='rm -r'       "Delete non empty directories with netrw
let g:windowswap_map_keys = 0        "prevent default bindings
let g:splitjoin_ruby_hanging_args = 0 "correct ruby split

"Surround
let g:surround_no_insert_mappings = 1
let g:surround_35 = "<%# \r %>"
let g:surround_37 = "<% \r %>"
let g:surround_61 = "<%= \r %>"

"deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#auto_completion_start_length=2
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

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
Plug 'tpope/vim-eunuch'

"tools
Plug 'tpope/vim-repeat'                "Better repeat
Plug 'tpope/vim-surround'              "surround verb
Plug 'tpope/vim-commentary'            "Easy comment
Plug 'sbdchd/vim-run'                  "Run scripts
Plug 'junegunn/vim-peekaboo'           "look at registers
Plug 'junegunn/vim-easy-align'         "easy align
Plug 'kana/vim-textobj-user'           "custom blocks
Plug 'bronson/vim-trailing-whitespace' "remove whitespaces
Plug 'AndrewRadev/splitjoin.vim'       "Line splitting
Plug 'tpope/vim-endwise'               "smart ends
Plug 'wesQ3/vim-windowswap'            "swap splits
Plug 'tommcdo/vim-exchange'            "cx/X to exchange
Plug 'adelarsq/vim-matchit'            "Better % match
Plug 'tpope/vim-abolish'               "Smart replace with :S
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "Fuzzy completion

"errors
Plug 'scrooloose/syntastic'

"Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

"HTML
Plug 'othree/html5.vim'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'cakebaker/scss-syntax.vim'

"Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'janko-m/vim-test'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'ecomba/vim-ruby-refactoring'

"Coffee
Plug 'kchmck/vim-coffee-script'

"Crystal
Plug 'rhysd/vim-crystal'

"Markdown
Plug 'plasticboy/vim-markdown'

"DB
Plug 'jlebray/vim-simpledb'

"Writing
Plug 'junegunn/goyo.vim'
Plug 'reedes/vim-pencil'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

"Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/seoul256.vim'
Plug 'jlebray/spacemacs-theme.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'jlebray/focused.vim'
Plug 'pgdouyon/vim-yin-yang'
Plug 'ewilazarus/preto'
Plug 'crusoexia/vim-dream'

call plug#end()


" ===== APPLY THEME =====

set background=dark
" let g:seoul256_background = 233
" colorscheme seoul256
colorscheme spacemacs-theme
" colorscheme PaperColor
" colorscheme focused
" colorscheme yin
" colorscheme preto
" colorscheme dream
highlight ExtraWhitespace guibg=#990000 ctermbg=red
highlight TermCursor ctermfg=red guifg=red

" ===== MAPPINGS =====

"Leader = Spacebar
let mapleader = " "

"ESC on jj
inoremap jj <ESC>
inoremap jk <ESC>

"Move between visual lines BUT keep correct count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap <c-n> J

"Run current file
nnoremap <leader>e :Run<cr>

"Copy to clipboard
vnoremap <leader>y "+y

"files
nnoremap <leader>fs  :w<cr>
nnoremap <leader>fe  :Run<cr>
nnoremap <leader>ff  :Files<cr>
nnoremap <leader>fr  :Move <c-R>%
nnoremap <leader>fd  :Remove<cr>
nnoremap <leader>fsw :SudoWrite <c-R>%<cr>

"Buffers
nnoremap <leader>bf :Buffers<cr>
nnoremap <tab> <C-^>

"Window
nnoremap <silent> <leader>wv :vsplit<cr>
nnoremap <silent> <leader>ws :split<cr>
nnoremap <silent> <leader>wd :q<cr>
nnoremap <silent> <leader>wh :wincmd h<cr>
nnoremap <silent> <leader>wj :wincmd j<cr>
nnoremap <silent> <leader>wk :wincmd k<cr>
nnoremap <silent> <leader>wl :wincmd l<cr>
nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>

"Tabs
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>te :tabedit %<cr>
nnoremap <leader>to :tabnew<cr>:Files<cr>
nnoremap <leader>td :tabclose<cr>
nnoremap K          :tabnext<cr>
nnoremap J          :tabprev<cr>

"Split/Join
nnoremap <leader>js gS
nnoremap <leader>jj gS

"Align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

"Git fugitive
nnoremap <leader>gpl :Gpull<cr>
nnoremap <leader>gps :Gpush<cr>
nnoremap <leader>gbl :Gblame<cr>
nnoremap <leader>gs  :Gstatus<cr>
nnoremap <leader>gl  :Git log --oneline --decorate --color --graph<cr>
nnoremap <leader>gc  :Gcommit<cr>
nnoremap <leader>gmv :Gmove<cr>
nnoremap <leader>grm :Gremove<cr>
nnoremap <leader>gco :Gread<cr>
nnoremap <leader>ga  :Gwrite<cr>
nnoremap <leader>gbf :Git checkout feature/
nnoremap <leader>gbd :Git checkout develop<cr>
nnoremap <leader>gbm :Git checkout master<cr>
nnoremap <leader>gd  :Git diff<cr>
nnoremap <leader>gds :Git diff --staged<cr>

"Vim
nnoremap <leader>vr :source ~/.vimrc<cr>
nnoremap <leader>ve :tabedit ~/.vimrc<cr>
nnoremap <leader>vq :qa!<cr>

"Plug
nnoremap <leader>pi  :PlugInstall<cr>
nnoremap <leader>pug :PlugUpgrade<cr>
nnoremap <leader>pud :PlugUpdate<cr>
nnoremap <leader>pc  :PlugClean<cr>

"Notes
nnoremap <leader>n  :Note<space>
nnoremap <leader>nd :DeleteNote!<cr>
nnoremap <leader>ns :SearchNotes<space>
vnoremap <leader>n  :NoteFromSelectedText<cr>

"Specs
nnoremap <Leader>sf :TestFile<CR>
nnoremap <Leader>st :TestNearest<CR>
nnoremap <Leader>sl :TestLast<CR>
nnoremap <Leader>ss :TestSuite<CR>
nnoremap <Leader>se :TestVisit<CR>

"Misc
nnoremap <silent> <leader>h :nohlsearch<cr><c-l>

"jump between errors
let g:syntastic_always_populate_loc_list = 1
nnoremap [e :lprev<cr>
nnoremap ]e :lnext<cr>

"Fuzzy finder configuration
"let g:fzf_files_options = '--preview \"(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'\"'
let g:fzf_files_options =
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'
nnoremap <F1> :Files<cr>
nnoremap <F2> :tabnew<cr>

"Remove search highlighting
nnoremap         *     *<c-o>

"Tags
nnoremap <F5> :ts<Space>

"Formating
nnoremap <F3> :Buffers<CR>
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

"Format JSON
function! FormatJSON()
  %!python -m json.tool
endfunction
command! FormatJSON call FormatJSON()

" ===== LAYERS =====

"Writing
nnoremap <leader>mws :Goyo 100<cr>:HardPencil<cr>:set spell<cr>
nnoremap <leader>mwq :Goyo<cr>:NoPencil<cr>:set nospell<cr>

" ===== CUSTOM BLOCKS =====

call textobj#user#plugin('erb', {
\   'code': {
\     'pattern': ['<%', '%>'],
\     'select-a': 'ay',
\     'select-i': 'iy',
\   },
\ })

call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })

function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction
