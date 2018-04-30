I do like the "Unix philosophy", as a result, I like to run compilers, test
suits and such in different terminals than my text editor's. However, this
involves some finger gymnastics (change window, then select previous command
and press enter, etc).

I wrote this script to automatize that. Instead of manually launching a
command, I press two keys in vim.

`command-server` sets up a named-pipe that it listens constantly to. It is
worth noting that it **executes without condition any code sent to that pipe**.
It complements the output of the command with colored markers so that the user
does not lose track of which command was ran, where the output begins and where
it ends.

The security implications of **arbitrary code execution** are disappointing.
Having access to the named pipe means you can already pretty much do anything
that you can do by executing code through `command-server`.

The plugin runs on neovim, I've no interest in adapting it for other use cases.
If you are interested in that task though (how weird, yet nice of you), I'm
open to your pull requests.

# Usage

## The script

`command-server.sh` creates a named pipe in `/tmp/command-server-pipe`
(hard-coded), It proceeds to execute every commands written on that file, line
by line. The command is in the form `<dirpath>#<command>` where `<dirpath>` is
the working directory in which to execute the command and `<command>` is a
shell command to execute.

## In vim

Simply run the `command-server.sh` script in a free terminal and use your
editor concurrently.

To send a command to execute, use the `:CmdSrvSend <command to run>`
command. **Note**: it will first save the file you are working on, and then
send the command.

I also wrote commands for usual operations such as program compilation and
testing. Those uses buffer-set variables: `b:cmdsrv_build`,`b:cmdsrv_test`
and `b:cmdsrv_run` to determine what commands to run for the corresponding
operation. You can set them in your own init files (`ftplugin/<language>.vim`)
to customize what commands will be ran by a command when editing which file.


# Installation

The plugin is installed through the standard means of vim plugin installs.

For the search functionality to work, one needs `rg` readily available in the
`PATH` environment variable.
