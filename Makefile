
# *************** env (start) ***************
export GOROOT_BOOTSTRAP?=/usr/lib/go
export GOHOSTOS:=$(shell ${GOROOT_BOOTSTRAP}/bin/go env GOHOSTOS)
export GOHOSTARCH:=$(shell ${GOROOT_BOOTSTRAP}/bin/go env GOHOSTARCH)
export GOOS?=${GOHOSTOS}
export GOARCH?=${GOHOSTARCH}
export CGO_ENABLED?=0

export GOPATH:=$(PWD)/gopath/
$(shell mkdir -p ${GOPATH}/bin ${GOPATH}/src ${GOPATH}/pkg)

GOHOST_BUILD_DIR:=go-${GOHOSTOS}-${GOHOSTARCH}-bootstrap
GOPROXY_BUILD_DIR:=goproxy-${GOOS}-${GOARCH}$(if $(GOARM),-$(GOARM))
# *************** env (end) ***************

.PHONY: go goproxy help clean distclean




help:
	@echo "usage: make [-B] [VAR=...] TARGET"
	@echo ""
	@echo "SUPPORT OPTIONS:"
	@echo "   -B"
	@echo "   --always-make  force update"
	@echo ""
	@echo "SUPPORT VARS:"
	@echo "   GOROOT_BOOTSTRAP=${GOROOT_BOOTSTRAP}"
	@echo "   GOOS=${GOOS}"
	@echo "   GOARCH=${GOARCH}"
	@echo "   GOARM=${GOARM}"
	@echo "   CGO_ENABLED=${CGO_ENABLED}"
	@echo "   see also https://golang.org/doc/install/source#environment"
	@echo ""
	@echo "SUPPORT TARGETS: "
	@echo "   go             build go."
	@echo "   goproxy        build goproxy."
	@echo "   clean          clean all file."
	@echo "   src-clean      clean dist file."
	@echo "   dist-clean     clean source file."
	@echo "   help           print this message and exit."
	@echo ""
	@echo "Report bugs to https://github.com/tc5832/goproxy_builder/issues."




go: go-${GOOS}-${GOARCH}-bootstrap 
	@echo "log(${@}): finished."
	@echo "********** log(${@}): dist dir \"$<\" **********"

go-%-bootstrap: go-src
	@echo ">>>>>>>>>> log(${@}): building phuslu/go... <<<<<<<<<<"
	${RM} -r $@
	cd go-src/src \
	              && GOOS=$(word 1,$(subst -, ,$*)) GOARCH=$(word 2,$(subst -, ,$*)) \
	                 ./bootstrap.bash

go-src:
	@echo ">>>>>>>>>> log(${@}): cloning phuslu/go... <<<<<<<<<<"
	test -d $@/.github || git clone https://github.com/phuslu/go.git $@
	cd $@ && git checkout master && git pull




goproxy: export PATH:=$(PWD)/${GOHOST_BUILD_DIR}/bin:$(PATH)
goproxy: export GOROOT:=$(PWD)/${GOHOST_BUILD_DIR}
goproxy: ${GOHOST_BUILD_DIR} ${GOPROXY_BUILD_DIR}
	@echo ">>>>>>>>>> log(${@}): building phuslu/goproxy... <<<<<<<<<<"
	cd ${GOPROXY_BUILD_DIR} \
	              && go get -d \
	              && GOOS= GOARCH= make GOOS=${GOOS} GOARCH=${GOARCH} CGO_ENABLED=${CGO_ENABLED}
	@echo "log(${@}): finished."
	@echo "********** log(${@}): dist dir \"${GOPROXY_BUILD_DIR}/build/${GOOS}_${GOARCH}/dist/\" **********"

goproxy-%: goproxy-src
	@echo ">>>>>>>>>> log(${@}): copying phuslu/goproxy... <<<<<<<<<<"
	${RM} -r $@
	cp -r $< $@

goproxy-src:
	@echo ">>>>>>>>>> log(${@}): cloning phuslu/goproxy... <<<<<<<<<<"
	test -d $@/.github || git clone https://github.com/phuslu/goproxy.git $@
	cd $@ && git checkout master && git pull




clean: dist-clean src-clean

dist-clean:
	@echo ">>>>>>>>>> log(${@}): cleaning dist... <<<<<<<<<<"
	${RM} -r go-*-bootstrap
	${RM}    go-*-bootstrap.tbz
	${RM} -r ${GOPATH}
	${RM} -r go-src goproxy-src goproxy-*-*
	${RM} -r goproxy-*-*

src-clean:
	@echo ">>>>>>>>>> log(${@}): cleaning source... <<<<<<<<<<"
	${RM} -r go-src goproxy-src

