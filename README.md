# Conscript

Run a command and restart it on each new line of STDIN.

<img src="http://sordina.binaries.s3.amazonaws.com/conscript.png" alt="Conscript Command Restarter" />

### Usage

    conscript command [args*]

## Examples

Use like 'watch':

    while true; do echo lol ; sleep 1; done | conscript ls


Useful in conjunction with [Commando](https://github.com/sordina/Commando):

    commando -c echo | grep --line-buffered Add  | conscript ls
