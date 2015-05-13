# go.mk
#
# Copyright (c) 2015, Herbert G. Fischer
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the organization nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL HERBERT G. FISCHER BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

APPBIN      := $(shell basename $(PWD))
GOSOURCES   := $(shell find . -type f -name '*.go')
GOPKGS      := $(shell go list ./...)
GOPKG       := $(shell go list)
COVERAGEOUT := coverage.out
COVERAGETMP := coverage.tmp

ifndef GOBIN
export GOBIN := $(GOPATH)/bin
endif

##########################################################################################
## Project targets
##########################################################################################

$(APPBIN): gomkbuild
	 
##########################################################################################
## Main targets
##########################################################################################

.PHONY: gomkbuild
gomkbuild: goenvcheck $(GOSOURCES) ; @go build 

.PHONY: gomkxbuild
gomkxbuild: ; $(GOX) 

.PHONY: gomkclean
gomkclean: goenvcheck
	@go clean
	@rm -f $(APPBIN)_*_386 $(APPBIN)_*_amd64 $(APPBIN)_*_arm $(APPBIN)_*.exe
	@rm -f $(COVERAGEOUT) $(COVERAGETMP)

##########################################################################################
## Go Environment Checks
##########################################################################################
.PHONY: gopath goenvcheck

goenvcheck: gopath
	@exit 0

gopath:
ifndef GOPATH
	$(error ERROR!! GOPATH must be declared. Check [http://golang.org/doc/code.html#GOPATH])
endif
ifeq ($(shell go list ./... | grep -q '^_'; echo $$?), 0)
	$(error ERROR!! This directory should be at $(GOPATH)/src/$(REPO)]
endif

##########################################################################################
## Go tools
##########################################################################################

GOTOOLDIR := $(shell go env GOTOOLDIR)
BENCHCMP  := $(GOTOOLDIR)/benchcmp
CALLGRAPH := $(GOTOOLDIR)/callgraph
COVER     := $(GOTOOLDIR)/cover
DIGRAPH   := $(GOTOOLDIR)/digraph
EG        := $(GOTOOLDIR)/eg
GODEX     := $(GOTOOLDIR)/godex
GODOC     := $(GOTOOLDIR)/godoc
GOIMPORTS := $(GOTOOLDIR)/goimports
GOMVPKG   := $(GOTOOLDIR)/gomvpkg
GOTYPE    := $(GOTOOLDIR)/gotype
ORACLE    := $(GOTOOLDIR)/oracle
SSADUMP   := $(GOTOOLDIR)/ssadump
STRINGER  := $(GOTOOLDIR)/stringer
VET       := $(GOTOOLDIR)/vet
GOX       := $(GOBIN)/gox
LINT      := $(GOBIN)/lint

$(BENCHCMP)  : goenvcheck ; @go get -v golang.org/x/tools/cmd/benchcmp
$(CALLGRAPH) : goenvcheck ; @go get -v golang.org/x/tools/cmd/callgraph
$(COVER)     : goenvcheck ; @go get -v golang.org/x/tools/cmd/cover
$(DIGRAPH)   : goenvcheck ; @go get -v golang.org/x/tools/cmd/digraph
$(EG)        : goenvcheck ; @go get -v golang.org/x/tools/cmd/eg
$(GODEX)     : goenvcheck ; @go get -v golang.org/x/tools/cmd/godex
$(GODOC)     : goenvcheck ; @go get -v golang.org/x/tools/cmd/godoc
$(GOIMPORTS) : goenvcheck ; @go get -v golang.org/x/tools/cmd/goimports
$(GOMVPKG)   : goenvcheck ; @go get -v golang.org/x/tools/cmd/gomvpkgs
$(GOTYPE)    : goenvcheck ; @go get -v golang.org/x/tools/cmd/gotype
$(ORACLE)    : goenvcheck ; @go get -v golang.org/x/tools/cmd/oracle
$(SSADUMP)   : goenvcheck ; @go get -v golang.org/x/tools/cmd/ssadump
$(STRINGER)  : goenvcheck ; @go get -v golang.org/x/tools/cmd/stringer
$(VET)       : goenvcheck ; @go get -v golang.org/x/tools/cmd/vet
$(LINT)      : goenvcheck ; @go get -v github.com/golang/lint/golint
$(GOX)       : goenvcheck ; @go get -v github.com/mitchellh/gox

.PHONY: vet
vet: $(VET) ; @for src in $(GOSOURCES); do go tool vet $$src; done

.PHONY: lint
lint: $(LINT) ; @for src in $(GOSOURCES); do golint $$src || exit 1; done

.PHONY: fmt
fmt: goenvcheck ; @go fmt

.PHONY: test
test: goenvcheck ; @go test -v ./...

.PHONY: race
race: goenvcheck ; @for pkg in $(GOPKGS); do go test -v -race $$pkg || exit 1; done

.PHONY: deps
deps: goenvcheck ; @go get -u -v -t ./...

.PHONY: cover
cover: goenvcheck $(COVER)
	@echo 'mode: set' > $(COVERAGEOUT)
	@for pkg in $(GOPKGS); do \
		go test -v -coverprofile=$(COVERAGETMP) $$pkg || exit 1; \
		grep -v 'mode: set' $(COVERAGETMP) >> $(COVERAGEOUT); \
		rm $(COVERAGETMP); \
	done
	@go tool cover -html=$(COVERAGEOUT)

##########################################################################################
## Make utilities
##########################################################################################

.PHONY: printvars
printvars:
	@$(foreach V, $(sort $(.VARIABLES)), $(if $(filter-out environment% default automatic, $(origin $V)), $(warning $V=$($V) )))
	@exit 0
