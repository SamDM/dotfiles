" This vimrc is partly created by me, and partly copied from various internet
" sources. Good sources are:
"    http://vim.wikia.com/wiki/Vim_Tips_Wiki
"    http://www.vimbits.com
"    http://rayninfo.co.uk/vimtips.html
"
" I'm actually using neovim instead of vim, which is a drop-in vim replacement
" with more advanced features such as:
"    * Asynchronous plugins
"    * Headless neovim servers that can be embedded in any gui-client (even
"      multiple at the same time)
"    * Performance optimizations
"    * Bracketed paste mode (no more pastetoggle trouble)
"    * Case sensitive Meta (alt) chords
"    * Complete built-in terminal emulator mirrored to any neovim-buffer,
"      this essentialy makes neovim a terminal multiplexer
" It is almost completely backwards compatible and supports most existing vim
" plugins. Check out:
"    https://github.com/neovim/neovim

"-------------------------------------------------------------------------------
" general settings
"-------------------------------------------------------------------------------

call plug#begin('~/.config/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'scrooloose/nerdcommenter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/vim-easy-align'
Plug 'pbrisbin/vim-syntax-shakespeare'

" Good plugins currently not installed:
"Plug 'equalsraf/neovim-gui-shim'

"Plug 'jalvesaq/Nvim-R'

"Plug 'neovimhaskell/haskell-vim'
"Plug 'bitc/vim-hdevtools'
"Plug 'neomake/neomake'

call plug#end()

" Enable vim-airline.
set laststatus=2
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1 " enable modified detection
let g:airline_detect_paste=1    " enable paste detection
let g:airline_detect_iminsert=0 " enable iminsert detection
let g:airline_theme="tomorrow"

" some sane defaults
syntax on
set ruler
set showcmd
set splitright
set number
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set foldmethod=syntax
set foldlevelstart=20
set hidden
set relativenumber
filetype on
filetype plugin on
filetype indent on
highlight ColorColumn ctermbg=red

" allow for project vimrc overrides
set exrc
set secure

" Backup options
set backup
set backupdir=~/.config/nvim/backdir

" Persistent undo history, this is a blessing
set undodir=~/.config/nvim/undodir
set undofile
set undolevels=100 "maximum number of changes that can be undone
set undoreload=100 "maximum number lines to save for undo on a buffer reload

" Switch syntax highlighting on, when the terminal has colors. Also switch on
" highlighting the last used search pattern.
set t_Co=256
set hlsearch

colorscheme deep-space
" Higlight 81th column (must come after theme loading to override theme color)
match ColorColumn '\%81v'

" Go to last line I edited before closing and center it
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
            \ exe "normal! g'\"zz" | endif

"-------------------------------------------------------------------------------
" general mappings
"-------------------------------------------------------------------------------
" Reminder: don't put comments after map commands, if you do the comment will
" be included in the command

" Why is Y the same as yy instead of y$ by default? Let's fix this
" unexplainable mistake
map Y y$

" Make \ the leader key
let mapleader = "\\"
let maplocalleader = ";"

" Press jj to exit insert mode, you'll never have to actually type jj in code
imap jj <esc>

" Turn of last search highlight
map <leader>h <esc>:noh<cr>:echo "cleared search highlight"<cr>

" Pres <space> to repeat macro in q register, super handy
nnoremap <Space> @q

" Show whitespaces
set listchars=eol:∟,tab:▷\ ,trail:◦,extends:⋗,precedes:⋖
" highlight whitespace_chars ctermfg=Black guifg=Black
" call matchadd('whitespace_chars', '\s\+$', 100) " matchadd = laggy
" call matchadd('whitespace_chars', '\t\+', 100)
map <leader>s <esc>:set invlist<cr>:echo "whitespaces toggle"<cr>

" Pasting options, handy in console vim
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
" Copy visual selection with Ctrl-C
vnoremap <c-c> "+y

" Easy buffer navigation
map <leader>b <esc>:bnext<CR>
map <leader>B <esc>:bpervious<CR>
" Easy tab navigation
map <A-t> :tabNext<CR>
tnoremap <A-t> <C-\><C-n>:tabNext<CR>

" Easily save stuff with Ctrl-s
map <C-s> :w<CR>
imap <C-s> <esc>:w<CR>

" escape terminal mode
tnoremap <A-q> <C-\><C-n>
" Seamless navigation between terminal and other windows
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" quickly split a terminal window
map <leader>tj <esc>:split<CR><C-w>j:terminal<CR>
map <leader>tk <esc>:split<CR><C-w>k:terminal<CR>
map <leader>th <esc>:vsplit<CR><C-w>h:terminal<CR>
map <leader>tl <esc>:vsplit<CR><C-w>l:terminal<CR>
" switch from terminal to previous buffer
tnoremap <A-b> <C-\><C-n>:bprevious<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"-------------------------------------------------------------------------------
" Syntastic
"-------------------------------------------------------------------------------

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = '➤'

"-------------------------------------------------------------------------------
" NERDtree
"-------------------------------------------------------------------------------

map <leader>nn <esc>:NERDTreeToggle<CR>
map <leader>nt <esc>:NERDTree<CR>
let g:NERDTreeShowBookmarks=1

"-------------------------------------------------------------------------------
" CtrlP
"-------------------------------------------------------------------------------

" CtrlP plugin mappings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_follow_symlinks=1
" setup some default ignores
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
            \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
            \}

" Use the nearest .git directory as the cwd
" This makes a lot of sense if you are working on a project that is in version
" control. It also supports works with .svn, .hg, .bzr.
let g:ctrlp_working_path_mode = 'r'

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>

"-------------------------------------------------------------------------------
" Hard mode
"-------------------------------------------------------------------------------

" Get rid of bad pracktices
"autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
"nnoremap <leader>w <Esc>:call ToggleHardMode()<CR>

"-------------------------------------------------------------------------------
" YouCompleteMe
"-------------------------------------------------------------------------------

nnoremap <leader>g :YcmCompleter GoTo<CR>
let g:ycm_confirm_extra_conf = 0

"-------------------------------------------------------------------------------
" UltiSnip
"-------------------------------------------------------------------------------

" UltiSnip plugin mappings
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-A-j>"
let g:UltiSnipsEditSplit="vertical"
map <leader>us <esc>:call UltiSnips#ListSnippets()<CR>

"-------------------------------------------------------------------------------
" for Rust & Rust vim
"-------------------------------------------------------------------------------

let g:rustfmt_autosave = 0
let g:ycm_rust_src_path = "/home/sam/Local/Rust-source/rust/src"
autocmd FileType rust map <leader>r :RustRun

"-------------------------------------------------------------------------------
" for LaTeX
"-------------------------------------------------------------------------------

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:syntastic_tex_checkers = []
autocmd FileType tex map <leader>ts <esc>:tabnew<CR>:e /tmp/scratch.tex<CR>
autocmd FileType tex map <leader>tc <esc>:split<CR><C-w>j:terminal<CR>latexmk -cd -pvc -halt-on-error -pdf /tmp/scratch.tex<CR>
autocmd FileType tex map <leader>to <esc>:!xdg-open /tmp/scratch.pdf<CR>

"-------------------------------------------------------------------------------
" for Cpp
"-------------------------------------------------------------------------------

autocmd FileType cpp vmap <leader>rf :!clang-format<CR>

"-------------------------------------------------------------------------------
" for perl
"-------------------------------------------------------------------------------

let perl_fold=1
" let sh_fold_enabled=1
let perl_extended_vars=1
" let perl_sync_dist=250
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'podchecker']
"let g:Perl_MapLeader  = '|'
autocmd FileType perl map <leader>rr <esc>:!perl -w %<enter>
autocmd FileType perl map <leader>rd <esc>:!perl -d %<enter>

"-------------------------------------------------------------------------------
" for Haskell
"-------------------------------------------------------------------------------

au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
let g:syntastic_haskell_checkers = ['hlint', 'scan']
