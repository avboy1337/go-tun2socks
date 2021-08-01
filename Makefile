GOCMD_LINUX=go
GOCMD_WIN=export GOOS=windows && export GOARCH=amd64 && export CC=x86_64-w64-mingw32-gcc && export CXX=x86_64-w64-mingw32-g+
+ && export CGO_ENABLED=1 && go
XGOCMD=xgo
GOBUILD_LINUX=$(GOCMD_LINUX) build
GOBUILD_WIN=$(GOCMD_WIN) build
GOCLEAN=$(GOCMD) clean
VERSION=$(shell git describe --tags)
DEBUG_LDFLAGS=''
RELEASE_LDFLAGS='-s -w -X main.version=$(VERSION)'
STATIC_RELEASE_LDFLAGS='-s -w -X main.version=$(VERSION) -extldflags "-static"'
BUILD_TAGS?=socks
BUILDDIR=$(shell pwd)/build
CMDDIR=$(shell pwd)/cmd/tun2socks
PROGRAM=tun2socks

BUILD_CMD_Linux="cd $(CMDDIR) && $(GOBUILD_LINUX) -ldflags $(RELEASE_LDFLAGS) -o $(BUILDDIR)/$(PROGRAM) -v -tags '$(BUILD_TAGS)'"
BUILD_WIN_CMD="cd $(CMDDIR) && $(GOBUILD_WIN) -ldflags $(RELEASE_LDFLAGS) -o $(BUILDDIR)/$(PROGRAM).exe -v -tags '$(BUILD_TAGS)'"
XBUILD_LINUX_CMD="cd $(BUILDDIR) && $(XGOCMD) -ldflags $(STATIC_RELEASE_LDFLAGS) -tags '$(BUILD_TAGS)' --targets=linux/* $(CMDDIR)"
XBUILD_OTHERS_CMD="cd $(BUILDDIR) && $(XGOCMD) -ldflags $(RELEASE_LDFLAGS) -tags '$(BUILD_TAGS)' --targets=darwin/*,windows/*,android/*,ios/* $(CMDDIR)"

all: build

linux:
	mkdir -p $(BUILDDIR)
	eval $(BUILD_CMD_Linux)
win:
	mkdir -p $(BUILDDIR)
	eval $(BUILD_WIN_CMD)
xbuild_linux:
	mkdir -p $(BUILDDIR)
	eval $(XBUILD_LINUX_CMD)

xbuild_others:
	mkdir -p $(BUILDDIR)
	eval $(XBUILD_OTHERS_CMD)

xbuild: xbuild_linux xbuild_others

travisbuild: xbuild

clean:
	rm -rf $(BUILDDIR)

cleancache:
	# go build cache may need to cleanup if changing C source code
	$(GOCLEAN) -cache
	rm -rf $(BUILDDIR)
