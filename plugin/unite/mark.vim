if exists('g:loaded_unite_source_mark')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:loaded_unite_source_mark = 1
let g:unite_source_mark_max_count = 10
let g:unite_source_mark_path = get(g:, 'unite_data_directory', expand('~/.unite')) . '/mark'

if !filereadable(g:unite_source_mark_path)
  call writefile([], g:unite_source_mark_path)
endif

command! -nargs=0 UniteMarkAdd call s:unite_mark_add()
function! s:unite_mark_add()
  let description = input('description: ')
  let pos = getpos('.')
  let file = fnamemodify(bufname('%'), ':p')

  if !filereadable(file)
    echo '`' . file . '` is not found.'
    return
  endif

  let content = readfile(g:unite_source_mark_path)[0:g:unite_source_mark_max_count]
  let line = join([file, pos[1], pos[2], description], "\t")
  let content = filter(content, 'v:val != line')
  call writefile([line] + content, g:unite_source_mark_path)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

