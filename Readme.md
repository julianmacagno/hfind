# hfind

## A GNU-find based tool written in Haskell

This is a tool based on the GNU-find utility which allow user to search for files in a directory hierarchy, based on their filename or extension.

This tool is very simple to use. Just call it and give it a path where to search, and a filename or a extension to search for.

This utility allows user to execute a shell command which takes a filaname path at the end of the order (like "rm"), since the tool concatenates the order with the result of the search.

### Installing hfind

To install this tool just download the sources files from https://github.com/julianmacagno/hfind and compile them using

`cabal update`
`cabal configure`
`cabal build`

Maybe you will have some dependencies issues. To fix it, install them with

`cabal install optparse-applicative filemanip process strings`

And install too all other missing dependencies you need for unknow reasons.

### Runing hfind

For running hfind just do

`hfind (-n|--fname) (-p|--path) [--exec]`

or

`hfind (-t|--ftype) (-p|--path) [--exec]`

Where the available options are:

  `-n,--fname`    Filename to search for

  `-t,--ftype`    Filetype to search for

  `-p,--path`     Path where to search for

  `-h,--help`     Show the help text

  `--exec`        Command to be excecuted at search result - This argument is optional