let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#mark#define()
  return [s:kind]
endfunction

let s:kind = {
      \ 'name': 'mark',
      \ 'default_action': 'open',
      \ 'parents': ['jump_list'],
      \ 'action_table': {},
      \ }

let s:kind.action_table.delete = {
      \ 'description': 'delete mark.',
      \ 'is_selectable': 1,
      \ 'is_invalidate_cache': 1,
      \ 'is_quit': 0,
      \ }
function! s:kind.action_table.delete.func(candidates)
  let marks = readfile(g:unite_source_mark_path)
  let new_marks = []

  let candidates = type(a:candidates) == type([]) ? a:candidates : [a:candidates]
  for mark in marks
    let found = 0
    for candidate in candidates
      if mark == candidate.action__mark.line
        let found = 1
      endif
    endfor

    if !found
      call add(new_marks, mark)
    endif
  endfor
  call writefile(new_marks, g:unite_source_mark_path)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

