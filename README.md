# GoMk

[![Join the chat at https://gitter.im/hgfischer/gomk](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/hgfischer/gomk?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

An opinionated Makefile for Go projects.

## Use cases

* How would you implement a building workflow using Go alongside other technologies?
* Do you remember how to run the commands to check the test coverage of you Go project?

## Usage

* Download `go.mk` to your project:
```
curl -O https://raw.githubusercontent.com/hgfischer/gomk/master/go.mk
```
* `include go.mk` in a new or existing Makefile;
* Check `Makefile.sample` to see some examples on how to integrate with
  your own build workflow:
```
curl -O https://raw.githubusercontent.com/hgfischer/gomk/master/Makefile.sample
```

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
* `gomkupdate`: update your go.mk file
* `vet`: run `go tool vet` in each source file 
* `lint`: run `golint` in each source file 
* `fmt`: run `go fmt` in the entire project 
* `test`: run `go test` for all pkgs in the project
* `race`: run `go test` with race detection in all pkgs in the project 
* `deps`: install all deps needed by the project 
* `cover`: run tests with coverage report in all pkgs in the projects
* `printvars`: print all variables defined in the Makefile

### Godep support (optional)

* `savegodeps`: save all deps with godep 
* `restoregodeps`: restore all deps with godep 
* `updategodeps`: update all deps with godep

## TODO

* Add targets for other tools
* Add support for `gb`
