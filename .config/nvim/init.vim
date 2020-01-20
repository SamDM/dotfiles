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

Plug 'chrisbra/csv.vim'
Plug 'chrisbra/unicode.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jalvesaq/Nvim-R'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug 'junegunn/vim-easy-align'
Plug 'qpkorr/vim-bufkill'

call plug#end()

" some sane defaults
syntax on
set ruler
set nowrap
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

" Switch on highlighting the last used search pattern.
set hlsearch

" Higlight 81th column (must come after theme loading to override theme color)
match ColorColumn '\%81v'

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

" Turn off last search highlight
map <leader>h <esc>:noh<cr>:echo "cleared search highlight"<cr>

" Pres <space> to repeat macro in q register, super handy
nnoremap <Space> @q

" Show whitespaces
set listchars=eol:∟,tab:▷\ ,trail:◦,extends:⋗,precedes:⋖
" highlight whitespace_chars
map <leader>s <esc>:set invlist<cr>:echo "whitespaces toggle"<cr>

" Copy visual selection with Ctrl-C
vnoremap <C-c> "+y

" Easy buffer navigation
map <leader>b <esc>:bnext<CR>
map <leader>B <esc>:bpervious<CR>
" Easy tab navigation
map <A-t> :tabNext<CR>
tnoremap <A-t> <C-\><C-n>:tabNext<CR>

" Easily save stuff with Ctrl-s
map <C-s> :w<CR>
imap <C-s> <esc>:w<CR>

" Seamless navigation between terminal and other windows
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
" escape terminal mode
tnoremap <A-q> <C-\><C-n>
" quickly split a terminal window
map <leader>tj <esc>:split<CR><C-w>j:terminal<CR>
map <leader>tk <esc>:split<CR><C-w>k:terminal<CR>
map <leader>th <esc>:vsplit<CR><C-w>h:terminal<CR>
map <leader>tl <esc>:vsplit<CR><C-w>l:terminal<CR>
" switch from terminal to previous buffer
tnoremap <A-b> <C-\><C-n>:bprevious<CR>
tnoremap <A-w> <C-\><C-n><C-w>p
nnoremap <A-w> <C-w>p

" EasyAlign
"------------------------------------------------------------------------------

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" CtrlP
"------------------------------------------------------------------------------

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
" Easy bindings for various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>
