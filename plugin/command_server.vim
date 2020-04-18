" Send specific commands to the command-server
" Send request to command-server to execute a:command inside the directory
" of the current file
" Definitively needs some work (ie: where to execute command depends on which
" type of project it is)
function! CmdSrvCmd(command)
	execute "update | !echo " . getcwd() . "\\#'" . a:command . "' >> /tmp/command-server-pipe"
endfunction
command! -nargs=1 -complete=file CmdSrvSend call CmdSrvCmd('<args>')

command! CmdSrvTest call CmdSrvCmd(g:cmdsrv_test)
command! CmdSrvBuild call CmdSrvCmd(g:cmdsrv_build)
command! CmdSrvRun call CmdSrvCmd(g:cmdsrv_run)

nnoremap <script> <silent> <Leader>b :CmdSrvBuild<CR><CR>
nnoremap <script> <silent> <Leader>r :CmdSrvRun<CR><CR>
nnoremap <script> <silent> <Leader>t :CmdSrvTest<CR><CR>
