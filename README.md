# GoMk

An opinionated Makefile for Go projects.

## Rationale

There are some large commands that the developer needs to remember to 
use and some of them are very important, such as the command to show 
the coverage of tests in a project. So instead of..

```
go test -v -coverprofile=coverage.tmp 
go tool cover -html=coverage.html 
``` 

...the GoMk user just needs to do 

```
make cover 
```

## Usage

* `include go.mk` in a new or existing Makefile;
* Check `Makefile.sample` to see some examples on how to integrate with
  your own build workflow.

## How it works

GoMk defines default variables and targets for a Go project, to help
maintain a healthy project. It also checks your current Go environment.

## Predefined variables

* `APPBIN`: name of the application, based on the repository name
* `GOSOURCES`: all `.go` files inside the project repository
* `GOPKGS`: all Go pkgs inside the project repository

*NOTE*: Check the go.mk file for other predefined variables that may 
conflict with other variables defined in your Makefile.

## Predefined targets

* `gomkbuild`: build the application binary, if there is one
* `gomkxbuild`: build all cross-platform binaries, using `gox`
* `gomkclean`: clean the project directory of the files produced by go.mk
* `vet`: run `go tool vet` in each source file 
* `lint`: run `golint` in each source file 
* `fmt`: run `go fmt` in the entire project 
* `test`: run `go test` for all pkgs in the project
* `race`: run `go test` with race detection in all pkgs in the project 
* `deps`: install all deps needed by the project 
* `cover`: run tests with coverage report in all pkgs in the projects
* `printvars`: print all variables defined in the Makefile

## TODO

* Add targets for other tools
* Add support for `gb`
