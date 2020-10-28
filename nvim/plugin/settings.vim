scriptencoding utf-8

set autoindent                            " maintain indent of current line
set backspace=indent,start,eol            " allow unrestricted backspacing in insert mode

if exists('$SUDO_USER')
  set nobackup
  set nowritebackup
else
  set backupdir=~/.tmp
endif

set cursorline

if exists('$SUDO_USER')
  set noswapfile                          " don't create root-owned files
else
  set directory=~/.tmp                    " keep swap files out if the way
endif

set expandtab                             " always use spaces instead of tabs

if has('folding')
  if has('windows')
    set fillchars=vert:┃                  " BOX DRAWING HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
    set fillchars+=fold:·                 " MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  endif
  set foldmethod=indent                   " faster than syntax
  set foldlevelstart=99                   " start unfolded
  set foldtext=folding#foldtext()
endif

if has('termguicolors')
  set termguicolors
end

set history=500                           " keep 50 lines of command line history
set hlsearch
set incsearch                             " do incremental searching
set laststatus=2                          " Always show status bar
set lazyredraw                            " don't update screen during macro playback

set list                                  " show whitespace
set listchars=nbsp:⦸                      " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8 E2 A6 B8)
set listchars+=tab:▷┅                     " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                                          " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505,
                                          " UTF-8: C2 BB)
set listchars+=extends:»                  " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«                 " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•                    " BULLET (U+2022, UTF-8: E2 80 A2)
set nojoinspaces                          " don't autoinsert two spaces after '.', '?', '!' for join command

set nowrap

set number
set relativenumber

set shiftwidth=2                          " spaces per tab (when shifting)

if has('showcmd')
  set noshowcmd                           " don't show extra info at end of command line
endif

set showmatch                             " jumps to matching bracket
set smarttab                              " <tab>/<BS> indent/dedent in leading whitespace
set softtabstop=2
set splitright
set termguicolors                         " use guifg/guibg instead of ctermfg/ctermbg in terminal
set viminfo+=!
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

highlight VertSplit none
