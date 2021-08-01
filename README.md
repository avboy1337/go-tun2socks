编译windows
```
sudo apt install mingw-w64 -y
export GOOS=windows
export GOARCH=amd64
export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++
export CGO_ENABLED=1
make
```

全局代理命令


```
chcp 65001
REM 把原来的默认路由删除
route delete 0.0.0.0 mask 0.0.0.0
REM 192.168.8.1为原来网关
REM route add 114.114.114.114 192.168.8.1 metric 5
REM route add 8.8.8.8 192.168.8.1 metric 5
REM 将发往代理服务器的流量转发到原来的网关 route add 代理服务器IP 原来网关IP metric 5
route add 42.157.196.178 192.168.8.1 metric 5
REM start cmd /k tun2socks.exe -proxyServer 127.0.0.1:1080 -tunAddr 10.0.0.2 -tunMask 255.255.255.0 -tunGw 10.0.0.1 -tunName "tun" -tunDns 8.8.8.8,114.114.114.114
start cmd /k tun2socks.exe -proxyServer 127.0.0.1:1080 -tunAddr 10.0.0.2 -tunMask 255.255.255.0 -tunGw 10.0.0.1 -tunName "tun"
REM 延迟5秒
choice /t 5 /d y /n >nul
REM 虚拟网卡指定为默认的路由出口
route add 0.0.0.0 mask 0.0.0.0 10.0.0.1 metric 5
REM 指定默认路由出口为网关
REM route add 0.0.0.0 mask 0.0.0.0 192.168.8.1 metric 5
```



# go-tun2socks

[![Build Status](https://travis-ci.com/eycorsican/go-tun2socks.svg?branch=master)](https://travis-ci.com/eycorsican/go-tun2socks)

A tun2socks implementation written in Go.

> If you're looking for an easy to use `tun2socks` implementation for iOS, you might be interested in [`leaf`](https://github.com/eycorsican/leaf) and [`ileaf`](https://github.com/eycorsican/ileaf).
> `leaf` [implements `tun2socks`](https://github.com/eycorsican/leaf/tree/master/leaf/src/proxy/tun/netstack) and it's written in Rust, with significantly less memory usage and significantly better performance compares to the Go version.

To run the tun2socks command line program, depending on OS, you may need to run it as root, create the TUN interface and/or configure IP address of the interface manually. Moreover, you should add corresponding routes to the routing table manually. Mind that you often want to use some different system DNS resolvers, and your proxy server should support UDP.

To use go-tun2socks as a library in your own project, refer to the following files/repos for some ideas:

- https://github.com/eycorsican/go-tun2socks/tree/master/cmd/tun2socks
- https://github.com/eycorsican/go-tun2socks-mobile
- https://github.com/Jigsaw-Code/outline-go-tun2socks

It's recommended to write your own SOCKS layer. For example, you can create a "tun2shadowsocks" program by implementing a Shadowsocks handler, see https://github.com/Jigsaw-Code/outline-go-tun2socks/tree/master/shadowsocks

It's also recommended to write your own TUN layer to connect the TUN interface and go-tun2socks, see https://github.com/eycorsican/go-tun2socks/tree/master/tun for examples.

The following projects are using go-tun2socks:

- https://github.com/mellow-io/mellow
- https://github.com/eycorsican/kitsunebi-android
