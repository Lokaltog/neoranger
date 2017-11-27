function! s:RangerOpenDir(...)
	let path = a:0 ? a:1 : getcwd()

	if !isdirectory(path)
		echom 'Not a directory: ' . path
		return
	endif

	let s:ranger_tempfile = tempname()
	let opts = ' --cmd="set viewmode multipane"'
	let opts .= ' --choosefiles=' . shellescape(s:ranger_tempfile)
	if a:0 > 1
		let opts .= ' --selectfile='. shellescape(a:2)
	else
		let opts .= ' ' . shellescape(path)
	endif
	let rangerCallback = {}

	function! rangerCallback.on_exit(id, code, _event)
		" Open previous buffer or new buffer *before* deleting the terminal 
		" buffer. This ensures that splits don't break if ranger is opened in 
		" a split window.
		if w:_ranger_del_buf != w:_ranger_prev_buf
			" Restore previous buffer
			exec 'silent! buffer! '. w:_ranger_prev_buf
		else
			" Previous buffer was empty
			enew
		endif

		" Delete terminal buffer
		exec 'silent! bdelete! ' . w:_ranger_del_buf

		unlet! w:_ranger_prev_buf w:_ranger_del_buf

		let names = ''
		if filereadable(s:ranger_tempfile)
			let names = readfile(s:ranger_tempfile)
		endif
		if empty(names)
			return
		endif
		for name in names
			exec 'edit ' . fnameescape(name)
			doautocmd BufRead
		endfor
	endfunction

	" Store previous buffer number and the terminal buffer number
	let w:_ranger_prev_buf = bufnr('%')
	enew
	let w:_ranger_del_buf = bufnr('%')

	" Open ranger in nvim terminal
	call termopen('ranger ' . opts, rangerCallback)
	startinsert
endfunction

" Override netrw
let g:loaded_netrwPlugin = 'disable'
augroup ReplaceNetrwWithRanger
	autocmd StdinReadPre * let s:std_in = 1
	autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | call s:RangerOpenDir(argv()[0]) | endif
augroup END

command! -complete=dir -nargs=* Ranger :call <SID>RangerOpenDir(<f-args>)
command! -complete=dir -nargs=* RangerCurrentFile :call <SID>RangerOpenDir(expand('%:p:h'), @%)
