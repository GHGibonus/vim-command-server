" Send specific commands to the command-server
" Send request to command-server to execute a:command inside the directory
" of the current file
" Definitively needs some work (ie: where to execute command depends on which
" type of project it is)
function! CmdSrvCmd(command)
	execute "update | !echo '%:p:h\\#" . a:command . "' >> /tmp/command-server-pipe"
endfunction
command! -nargs=1 -complete=file CmdSrvSend call CmdSrvCmd('<args>')

function! CmdSrvSearchFun(regex)
	execute "!echo '" . getcwd() . "\\#rg \"\\b" . a:regex . "\\b\"' >> /tmp/command-server-pipe"
endfunction


command! CmdSrvTest call CmdSrvCmd(b:cmdsrv_test)
command! CmdSrvBuild call CmdSrvCmd(b:cmdsrv_build)
command! CmdSrvRun call CmdSrvCmd(b:cmdsrv_run)
command! -nargs=1 -complete=file CmdSrvSearch call CmdSrvSearchFun('<args>')

nnoremap <script> <silent> <Leader>b :CmdSrvBuild<CR><CR>
nnoremap <script> <silent> <Leader>r :CmdSrvRun<CR><CR>
nnoremap <script> <silent> <Leader>t :CmdSrvTest<CR><CR>
nnoremap <script> <silent> <Leader>s :CmdSrvSearch <C-r><C-w><CR><CR>
vnoremap <script> <silent> <Leader>s y:CmdSrvSearch <C-r>0<CR><CR>
