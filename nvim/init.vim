" NeoVim init - Johan Le Bray
" {{{ ===== SETTINGS
syntax on
set autoindent
set complete=.,w,b,u,t,i
set cursorline
set dictionary="/usr/dict/words"
set expandtab
set foldmethod=marker
set hidden
set history=100
set hlsearch
set ignorecase
set laststatus=2
set lazyredraw
set mouse=a
set nobackup
set noswapfile
set number
set relativenumber
set rtp+=/usr/local/opt/fzf
set ruler
set scrolloff=10
set shiftround
set shiftwidth=2
set smartcase
set smarttab
set softtabstop=2
set spelllang=fr
set splitbelow
set splitright
set tabstop=2
set timeoutlen=500 ttimeoutlen=0
set title
set visualbell
set wildignorecase
set wildmode=list:full,full
if (has("termguicolors"))
  set termguicolors
endif
if exists('&inccommand')
  set inccommand=split
endif

autocmd BufRead,BufNewFile *.{arb} set filetype=ruby
autocmd BufRead,BufNewFile *.{ecr} set filetype=html
autocmd BufRead,BufNewFile *.{tex} set spell breakindent linebreak
autocmd BufRead,BufNewFile *.scss.css setfiletype scss
autocmd BufRead,BufNewFile *.less setfiletype css

" }}}
" {{{ ===== PLUGINS
" {{{ Options
let g:airline_powerline_fonts = 1    "powerline fonts
let g:airline_theme='base16_spacemacs'     "powerline fonts
if executable('ag')
  let g:ackprg = 'ag --vimgrep'      "The silver searcher
endif
let g:netrw_localrmdir='rm -r'       "Delete non empty directories with netrw

"Surround
let g:surround_no_insert_mappings = 1
let g:surround_35 = "<%# \r %>"
let g:surround_37 = "<% \r %>"
let g:surround_61 = "<%= \r %>"

"deoplete
let g:deoplete#enable_at_startup=1
let g:deoplete#auto_completion_start_length=2
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ["neosnippet"]
function! s:neosnippet_complete()
  if neosnippet#expandable_or_jumpable()
    return "\<Plug>(neosnippet_expand_or_jump)"
  else
    if pumvisible()
      return "\<c-n>"
    else
      return "\<tab>"
    endif
  endif
endfunction

imap <expr><TAB> <SID>neosnippet_complete()

"multi cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-b>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

"argwrap
let g:argwrap_padded_braces = '{'
let g:argwrap_tail_comma_braces = '[{'

"neoterm
let g:neoterm_position = 'vertical'

"neomake
let g:neomake_ruby_enabled_makers = ["rubocop"]
let g:neomake_json_enabled_makers = ["jsonlint"]
let g:ruby_doc_command='open'
autocmd! BufRead,BufWritePost * Neomake

" }}}
" {{{ Sources
"install vim-plug if not present
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

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
Plug 'junegunn/vim-easy-align'         "easy align
Plug 'kana/vim-textobj-user'           "custom blocks
Plug 'bronson/vim-trailing-whitespace' "remove whitespaces
Plug 'FooSoft/vim-argwrap'             "Line splitting
Plug 'tpope/vim-endwise'               "smart ends
Plug 'tommcdo/vim-exchange'            "cx/X to exchange
Plug 'adelarsq/vim-matchit'            "Better % match
Plug 'tpope/vim-abolish'               "Smart replace with :S
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "Fuzzy completion
Plug 'terryma/vim-multiple-cursors'
Plug 'sheerun/vim-polyglot'
Plug 'kshenoy/vim-signature'
Plug 'kassio/neoterm'                  "Fast access to terminal
Plug 'wellle/targets.vim'              "Improve text objects
Plug 'AndrewRadev/splitjoin.vim'
Plug 'mhinz/vim-startify'
Plug 'brooth/far.vim'

"snippets
Plug 'Shougo/neosnippet'
Plug 'jlebray/snippets'

"errors
Plug 'neomake/neomake'

"Git
Plug 'lambdalisue/gina.vim' "Git in vim
Plug 'tpope/vim-fugitive'   "Keep for blame
Plug 'mhinz/vim-signify'
Plug 'jreybert/vimagit'

"HTML
Plug 'othree/html5.vim'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'cakebaker/scss-syntax.vim'
Plug 'vim-scripts/liquid.vim'          "Liquid syntax

"Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'lucapette/vim-ruby-doc'
Plug 'tpope/vim-rails'

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
Plug 'pgdouyon/vim-yin-yang'
Plug 'ewilazarus/preto'
Plug 'crusoexia/vim-dream'

call plug#end()
" }}}
" }}}
" {{{ ===== THEME
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

" }}}
" {{{ ===== MAPPINGS
"Leader = Spacebar
let mapleader = " "

"Move between visual lines BUT keep correct count
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> k v:count ? 'k' : 'gk'

"Keep selection when indenting
vnoremap < <gv
vnoremap > >gv

"J is used to switch tabs, so use C-n to join lines
nnoremap <c-n> J

"Run current file
nnoremap <leader>e :Run<cr>

"Copy to clipboard
vnoremap <leader>y "+y

nmap Y y$

"files
nnoremap <leader>s  :w<cr>
nnoremap <leader>f  :Files<cr>
nnoremap <leader>r  :Move <c-R>%
nnoremap <leader>x  :Remove<cr>
nnoremap <leader>n  :Ag<cr>

"Buffers
nnoremap <leader>b :Buffers<cr>
nnoremap <tab> <C-^>
nnoremap <leader>/ :BLines<cr>

"Window
nnoremap <silent> <leader>1 :only<cr>
nnoremap <silent> <leader>2 :vsplit<cr>
nnoremap <silent> <leader>3 :split<cr>
nnoremap <silent> <leader>d :q<cr>

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
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)

"Git
nnoremap <leader>gs  :Gina status<cr>
nnoremap <leader>gc  :Gina commit<cr>
nnoremap <leader>gp  :Gina push<cr>
nnoremap <leader>gb  :Gblame<cr>

"NeoVim
nnoremap <leader>vr :source ~/.config/nvim/init.vim<cr>
nnoremap <leader>ve :tabedit ~/.config/nvim/init.vim<cr>
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

"Misc
nnoremap <silent> <leader>h :nohlsearch<cr><c-l>
nnoremap <silent> <leader>l :ArgWrap<CR>

"jump between errors
let g:syntastic_always_populate_loc_list = 1
nnoremap [e :lprev<cr>
nnoremap ]e :lnext<cr>

"Fuzzy finder configuration
"let g:fzf_files_options = '--preview \"(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'\"'
let g:fzf_files_options =
  \ '--preview "(coderay {} || cat {}) 2> /dev/null | head -'.&lines.'"'

"Remove search highlighting
nnoremap * *<c-o>

"Tags
nnoremap <F5> :Tags<cr>

nnoremap <Leader>w :FixWhitespace<CR>
nnoremap <leader><leader> :T<space>

" }}}
" {{{ ===== MISC
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

"Center startify
function! s:filter_header(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction
let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())
" }}}
" {{{ ===== CUSTOM BLOCKS
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
" }}}
