" Maintainer:	Matthew Simo <matthew.a.simo@gmail.com>
" Last change: 2012 08 28

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

call pathogen#infect()

set backupdir=~/.vim/backup

"set nowrap
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set nofoldenable
set smarttab
set cmdheight=2
set copyindent
"let &showbreak=repeat('  ', IndentLevel(line('.')))
"let &showbreak=repeat('  ', IndentLevel(line('.'))+1)

"syntax highlighting & solarized config
syntax on
let &t_Co=256
"let g:solarized_termcolors=256
let g:solarized_degrade=0
let g:solarized_italic=1
let g:solarized_bold=1
let g:solarized_underline=1
colorscheme solarized
set background=dark

" Set Indicator for various modes
function! InsertStatuslineColor(mode)
	if a:mode == 'i'
		hi statusline cterm=NONE ctermbg=DarkBlue ctermfg=Black
	elseif a:mode == 'r' || 'Rv'
		hi statusline cterm=NONE ctermbg=DarkRed ctermfg=White
  elseif a:mode == 'v' || 'V'
    hi statusline cterm=NONE ctermbg=Cyan ctermfg=Black
  elseif a:mode == 'c' || 'cv' || 'ce'
    hi statusline cterm=NONE ctermbg=Black ctermfg=White
  else
    hi statusline cterm=NONE ctermbg=DarkYellow ctermfg=Black
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline cterm=NONE ctermbg=DarkYellow ctermfg=Black


" Default the statusline to Black on grey when entering vimrc
hi statusline cterm=NONE ctermbg=DarkYellow ctermfg=Black
" Default the statusline to white in Not Current windows
hi StatusLineNC cterm=NONE ctermfg=Gray ctermbg=Black
" Default Cursor line in current window only.
set cursorline
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
"hi CursorLine cterm=NONE ctermbg=DarkGreen ctermfg=White


set magic
set showmatch
set noerrorbells
set hlsearch
set paste


" Always show the status line @ 2 lines
set laststatus=2

" Format the status line
set statusline = " Left Side stuff - start status line
set statusline+=\ %f " {file name}
set statusline+=\ %y " {file type}
set statusline+=\ %m " {modified flag} 
set statusline+=\ %r " {read only flag}
set statusline+=\ %h " {help buffer flag}
set statusline+=\ %w " {preview bugger flag}
set statusline+=\ \ CWD:\ %{getcwd()} " CWD stuff - limited to 4 directories or 40 characters, which ever comes first
set statusline+=\%= " Move to the right align stuff
set statusline+=\ %{HasPaste()} " Check if it's in paste mode - if so, output [paste mode]
set statusline+=\ %1*%{FindMode(mode())}%*\ " Mode notification bit
set statusline+=\ %4.6c:%l/%L[%p%%]\  " Set column:CurrentLine/TotalLines[Percentage]

hi User1 cterm=bold
autocmd vimenter * if !argc() | NERDTree | endif


" ========================================
" Custom Commands
" ========================================

" Map some keys for easier tab usage
map <S-h> :tabfirst<CR>
map <S-j> :tabprevious<CR>
map <S-k> :tabnext<CR>
map <S-l> :tablast<CR>

" Map for nerd tree - to control n in normal mode
nmap <silent> <c-n> :NERDTreeToggle<CR>

" Map for Search/Replate Trailing White space
map ,s :call DeleteTrailingWS()<CR>

command C let @/=""
" ========================================
" Custom Commands
" ========================================

" Highlight trailing white space for find/replace
func! DeleteTrailingWS()
  exec ':%s/ \+$//gc'
endfunc


" Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif


" Remember info about open buggers on close
set viminfo^=%


" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    return '[paste mode]'
  endif
  return ''
endfunction


"Return Mode Based on Mode ID Char
function! FindMode(mode_char)
	if a:mode_char == 'n'
    return ' NORMAL '
  elseif a:mode_char == 'v' || a:mode_char == 'V'
    return ' VISUAL '
  elseif a:mode_char == 'i'
    return ' INSERT '
  elseif a:mode_char == 'R' || a:mode_char == 'Rv'
    return ' REPLACE '
  else
    return a:mode_char
  endif
endfunction


" ========================================

" Visual * - Search for selected text * = next # = prev

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" ========================================

let disable_lint = 1
