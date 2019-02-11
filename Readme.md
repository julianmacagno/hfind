# hfind

## A GNU-find based tool written in Haskell

This is a tool based on the GNU-find utility which allow user to search for files in a directory hierarchy, based on their filename or extension.

This tool is very simple to use. Just call it and give it a path where to search, and a filename or a extension to search for.

This utility allows user to execute a shell command which takes a filaname path at the end of the order (like "rm"), since the tool concatenates the order with the result of the search.

### Installing hfind

To install this tool just download the sources files from https://github.com/julianmacagno/hfind and compile them using

`cabal update`

`cabal install`

`cabal configure`

`cabal build`

### Runing hfind

For running hfind just do

`hfind (-n|--fname) [-p|--path] [--exec]`

or

`hfind (-t|--ftype) [-p|--path] [--exec]`

Where the available options are:

  `-n,--fname`    Filename to search for

  `-t,--ftype`    Filetype to search for

  `-p,--path`     Path where to search for - Optional

  `--exec`        Command to be excecuted at search result - Optional

  `-h,--help`     Show the help text

### Authors:
- Julián Ignacio Macagno. Oncativo, Cordoba, Argentina. 
  julian.macagno55@gmail.com

**Tested successfully on ghc 8.0.1 and cabal 1.24.0.1**

### Dependencies are: 
- **base 4.9** - Haskell standard libraries
- **process 1.6.5.0** - Haskell standard libraries
- **optparse-applicative 0.14.3.0** - Paolo Capriotti & Huw Campbell.
- **filemanip 0.3.6.3** - Braian O' Sullivan.
- **strings 1.1** - Julian Fleischer.