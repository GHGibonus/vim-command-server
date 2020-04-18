I do like the "Unix philosophy", as a result, I like to run compilers, test
suits and such in different terminals than my text editor's. However, this
involves some finger gymnastics (change window, then select previous command
and press enter, etc).

I wrote this script to automatize that. Instead of manually launching a
command, I press two keys in vim.

`command-server` sets up a named-pipe and listens to it. It is
worth noting that it **executes without condition any code sent to that pipe**.
It complements the output of the command with colored markers to facilitate
reading of command output with scrollback.

The security implications of **arbitrary code execution** are disappointing.
Having access to the named pipe means you can already pretty much do anything
that you can do by executing code through `command-server`.

The plugin runs on neovim, I've no interest in adapting it for other use cases.
If you are interested in that task though (how weird, yet nice of you), I'm
open to your pull requests.

# Usage

## The script

`command-server.sh` creates a named pipe in `/tmp/command-server-pipe`
(hard-coded), It proceeds to execute every commands pushed that file, line
by line. The command is in the form `<dirpath>#<command>` where `<dirpath>` is
the working directory in which to execute the command and `<command>` is a
shell command to execute.

I have to deal with sbt at work, which assumes a certain pattern of interaction
due to its massive startup time. This is why there is a special case for it in
`command-server.sh`.

## In vim

Simply run the `command-server.sh` script in a free terminal and use your
editor concurrently.

To send a command to execute, use the `:CmdSrvSend <command to run>`
command. **Note**: it will first save the file you are working on, and then
send the command.

I also wrote commands for usual operations such as program compilation and
testing. Those uses global variables: `g:cmdsrv_build`,`g:cmdsrv_test`
and `g:cmdsrv_run` to determine what commands to run for the corresponding
operation. You can set them in your own init files (`ftplugin/<language>.vim`)
to customize what commands will be run when editing which file type.


# Installation

The plugin is installed through the standard means of vim plugin installs.
Something like:
```vim
  Plug "GHGibonus/command-server"
```
should do the trick with the `Plug` vim plugin manager installed. I personally
use `dein`, but the API is very similar.
