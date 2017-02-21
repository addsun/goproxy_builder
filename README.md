## Goproxy Builder
一个小巧、干净、功能强大的Makefile文件, 用来编译[phuslu/goproxy](https://github.com/phuslu/goproxy).

#### 用法:
```
usage: make [-B] [VAR=...] TARGET

SUPPORT OPTIONS:
   -B
   --always-make  force update

SUPPORT VARS:
   GOROOT_BOOTSTRAP=/usr/lib/go
   GOOS=linux
   GOARCH=amd64
   GOARM=
   CGO_ENABLED=0
   see also https://golang.org/doc/install/source#environment

SUPPORT TARGETS: 
   go             build go.
   goproxy        build goproxy.
   clean          clean all file.
   src-clean      clean dist file.
   dist-clean     clean source file.
   help           print this message and exit.
```

#### 例子:
- linux32位: `make GOOS=linux GOARCH=386 goproxy`
- linux64位: `make GOOS=linux GOARCH=amd64 goproxy`
- linux arm 32位: `make GOOS=linux GOARCH=arm goproxy`
- linux arm 64位: `make GOOS=linux GOARCH=arm64 goproxy`
- linux arm 32位 EABI5: `make GOOS=linux GOARCH=arm GOARM=5 goproxy`
- windows32位: `make GOOS=windows GOARCH=386 goproxy`
- windows64位: `make GOOS=windows GOARCH=amd64 goproxy`

#### 关于"GOOS"和"GOARCH"
参考: [Installing Go from source \- The Go Programming Language](https://golang.org/doc/install/source#environment)
