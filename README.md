# Neoranger

## Introduction

**Neoranger is a simple ranger wrapper script for neovim. It's inspired by Drew 
Neil's [thoughs on project 
drawers](http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/). 
It's like [vinegar](https://github.com/tpope/vim-vinegar) or 
[filebeagle](https://github.com/jeetsukumaran/vim-filebeagle), but with ranger 
as the interface.**

Neoranger opens a terminal with ranger in the current window. It sets ranger's 
viewmode to `multipane`, making it easy to use in narrow windows. You can 
select and open multiple files.

The wrapper script ensures that split windows don't break when the terminal 
window is closed, by restoring the previous buffer in the current window.

Note that neoranger replaces netrw.

## Usage

Neoranger provides two commands, `:Ranger` and `:RangerCurrentFile`.

`:Ranger` accepts an optional directory and file argument. If no arguments are 
provided it opens ranger in the current working directory.

`:RangerCurrentFile` opens ranger and selects the currently open file.

## Mappings

Neoranger doesn't add any mappings by default. The following mappings makes 
neoranger behave like vinegar or filebeagle:

```vim
" Open ranger at current file with "-"
nnoremap <silent> - :RangerCurrentFile<CR>

" Open ranger in current working directory
nnoremap <silent> <Leader>r :Ranger<CR>
```
