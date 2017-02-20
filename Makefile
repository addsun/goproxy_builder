
# *************** env (start) ***************
export GOPATH:=$(PWD)/gopath/
$(shell mkdir -p ${GOPATH}/{bin,src,pkg})
export GOOS:=linux
export GOARCH:=amd64
export GOROOT_BOOTSTRAP:=/usr/lib/go

$(info info: GOPATH=${GOPATH})
$(info info: GOOS=${GOOS})
$(info info: GOARCH=${GOARCH})
$(info info: GOROOT_BOOTSTRAP=${GOROOT_BOOTSTRAP})


GO_BUILDDIR:=go-${GOOS}-${GOARCH}-bootstrap
GOPROXY_BUILDDIR:=goproxy-${GOOS}-${GOARCH}
$(info info: GO_BUILDDIR=${GO_BUILDDIR})
$(info info: GOPROXY_BUILDDIR=${GOPROXY_BUILDDIR})
$(info )
# *************** env (end) ***************

.PHONY: help clean distclean




help:
	@echo "usage:"
	@echo "1. build: make goproxy"
	@echo "2. update: (TODO)"
	@echo "3. force-update: make -B goproxy"
	@echo "4. clean: make clean"
	@echo "5. distclean: make distclean"
	@echo "6. help: make help"




go: ${GO_BUILDDIR} 

${GO_BUILDDIR}: go-src
	@echo ">>>>>>>>>> log(${@}): building phuslu/go... <<<<<<<<<<"
	${RM} -r $@
	cd go-src/src && ./bootstrap.bash

go-src:
	@echo ">>>>>>>>>> log(${@}): cloning phuslu/go... <<<<<<<<<<"
	[[ -d $@/.github ]] || git clone https://github.com/phuslu/go.git $@
	cd $@ && git checkout master && git pull




goproxy: export PATH:=$(PWD)/${GO_BUILDDIR}/bin:$(PATH)
goproxy: export GOROOT:=$(PWD)/${GO_BUILDDIR}
goproxy: go ${GOPROXY_BUILDDIR}
	@echo ">>>>>>>>>> log(${@}): building phuslu/goproxy... <<<<<<<<<<"
	cd ${GOPROXY_BUILDDIR} \
	              && go get -d \
	              && make
	@echo "log(${@}): finished."
	@echo "log(${@}): dist dir \"${GOPROXY_BUILDDIR}/build/${GOOS}_${GOARCH}/dist/\""

${GOPROXY_BUILDDIR}: goproxy-src
	@echo ">>>>>>>>>> log(${@}): copying phuslu/goproxy... <<<<<<<<<<"
	${RM} -r $@
	cp -r $< $@

goproxy-src:
	@echo ">>>>>>>>>> log(${@}): cloning phuslu/goproxy... <<<<<<<<<<"
	[[ -d $@/.github ]] || git clone https://github.com/phuslu/goproxy.git $@
	cd $@ && git checkout master && git pull




clean:
	@echo ">>>>>>>>>> log(${@}): cleaning... <<<<<<<<<<"
	${RM} -r ${GO_BUILDDIR}
	${RM} -r ${GO_BUILDDIR}.tbz
	${RM} -r ${GOPATH}

distclean: clean
	@echo ">>>>>>>>>> log(${@}): distcleaning... <<<<<<<<<<"
	${RM} -r go-src goproxy-src ${GOPROXY_BUILDDIR} 

