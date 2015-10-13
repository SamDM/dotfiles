" This vimrc is partly created by me, and partly copied from various internet
" sources. Good sources are:
"    http://vim.wikia.com/wiki/Vim_Tips_Wiki
"    http://www.vimbits.com
"    http://rayninfo.co.uk/vimtips.html
"
"
" All vim plugins are installed with pacman using the official arch
" repositories and AUR, which is a better package manager than
" pathogen/vundle/etc.
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

" Plugins installed with pacman don't end up in the runtime path of neovim,
" therefore the default vim runtime path is added here to neovims runtime
" path.
if has('nvim')
    set runtimepath+=/usr/share/vim/vimfiles,/usr/share/vim/vim74,/usr/share/vim/vimfiles/after
endif

" Enable vim-airline. DejaVu font with powerline patch works ok
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
set laststatus=2
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline_detect_modified=1 " enable modified detection >
let g:airline_detect_paste=1 " enable paste detection >
let g:airline_detect_iminsert=0 " enable iminsert detection >
let g:airline_theme="bubblegum"

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
filetype plugin on
highlight ColorColumn ctermbg=red
match ColorColumn '\%81v'

" Backup options
set backup
set backupdir=~/.vim/backdir

" Persistent undo history, this is a blessing
set undodir=~/.vim/undodir
set undofile
set undolevels=100 "maximum number of changes that can be undone
set undoreload=100 "maximum number lines to save for undo on a buffer reload

" Switch syntax highlighting on, when the terminal has colors. Also switch on
" highlighting the last used search pattern.
set t_Co=256
set hlsearch
" override color scheme to make background transparent
" autocmd ColorScheme * highlight Normal ctermbg=None
" autocmd ColorScheme * highlight NonText ctermbg=None
let g:rehash256 = 1 " tells molokai to use 256 color scheme
colorscheme molokai
" Higlight 81th column (must come after theme loading to override theme color)

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

if has('nvim')
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
endif

"-------------------------------------------------------------------------------
" Syntastic
"-------------------------------------------------------------------------------

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

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
" UltiSnip
"-------------------------------------------------------------------------------

" UltiSnip plugin mappings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"
map <leader>us <esc>:call UltiSnips#ListSnippets()<CR>

"-------------------------------------------------------------------------------
" for LaTeX
"-------------------------------------------------------------------------------

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:syntastic_tex_checkers = []

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
