" Send specific commands to the command-server
" Send request to command-server to execute a:command inside the directory
" of the current file
" Definitively needs some work (ie: where to execute command depends on which
" type of project it is)
function! RunCmdServerCmd(command)
	execute "update | !echo '%:p:h\\#" . a:command . "' >> /tmp/command-server-pipe"
endfunction

command! CmdTest call RunCmdServerCmd(b:test_cmd)
command! CmdBuild call RunCmdServerCmd(b:build_cmd)
command! CmdRun call RunCmdServerCmd(b:run_cmd)
nnoremap <script> <buffer> <silent> <Leader>b :CmdBuild<CR><CR>
nnoremap <script> <buffer> <silent> <Leader>r :CmdRun<CR><CR>
nnoremap <script> <buffer> <silent> <Leader>t :CmdTest<CR><CR>
