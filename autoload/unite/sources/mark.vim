let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#mark#define()
  return s:source
endfunction

let s:source = {
      \ 'name': 'mark',
      \ 'hooks': {},
      \ }

function! s:source.hooks.on_init(args, context)
  let a:context.source__marks = map(readfile(g:unite_source_mark_path), 's:create_mark(v:val)')
  let a:context.source__marks = filter(a:context.source__marks, '!empty(v:val)')
endfunction

function! s:source.gather_candidates(args, context)
  return map(a:context.source__marks, "{
        \   'word': fnamemodify(v:val.path, ':t') . '(' . v:val.lnum . ')' . ' | ' . v:val.description,
        \   'kind': 'jump_list',
        \   'action__path': v:val.path,
        \   'action__line': v:val.lnum,
        \ }")
endfunction

function! s:create_mark(line)
  try
    let [path, lnum, col, description] = split(a:line, "\t")
  catch
    return {}
  endtry
  return {
        \ 'path': path,
        \ 'lnum': lnum,
        \ 'col': col,
        \ 'description': description,
        \ }
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
