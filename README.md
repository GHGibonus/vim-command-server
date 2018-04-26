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

The security implications of **arbitrary code execution** are disapointing.
Having access to the named pipe means you can already pretty much do anything
that you can do by executing code through `command-server`.

The plugin runs on neovim, I've no interest in adapting it for other use cases.
If you are interested in that task though (how weird, yet nice of you), I'm
open to your pull requests.

The vim plugin expects `command-server.sh` to be called `command-server`
(notice the distinct lack of `.sh`) and be in a directory within `PATH`.
Typically this is done through a symlink.

The plugin is installed through the standard means of vim plugin installs.
