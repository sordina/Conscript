# Conscript

Run a command and restart it on each new line of STDIN.

<img src="http://sordina.binaries.s3.amazonaws.com/conscript.png" alt="Conscript Command Restarter" />

### Usage

    conscript command [args*]

## Examples

Use like 'watch':

    while true; do echo lol ; sleep 1; done | conscript ls

Which is equivalent to the `xargs` command:

    while true; do echo lol ; sleep 1; done | xargs -L 1 -I % ls

Where `Conscript` differs from `xargs` is that if the script is a
long-running process, then subsequent incoming lines will kill that
process and restart it, rather than wait for it to finish.


Useful in conjunction with [Commando](https://github.com/sordina/Commando):

    commando -c echo | grep --line-buffered Add  | conscript ls

Another example - Watch updates to a file:

    commando | conscript bash -c "clear && less file.txt"


## Binaries

* [conscript-1.0.0.0-MacOSX-10.7.5-11G63b.zip](http://sordina.binaries.s3.amazonaws.com/conscript-1.0.0.0-MacOSX-10.7.5-11G63b.zip)
