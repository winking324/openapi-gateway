# 开放网关

## 初始化

按照 `scripts/init.sh` 脚本，逐步执行即可。

## 启动服务

为了保证网关的安全性，先修改 `conf/nginx-whitelist.conf`，将自己本地的出口 IP 设置为允许，这样只有本地可以登陆修改网关配置。

接下来，直接使用 `docker-compose up -d` 启动服务即可。

## 注册免费证书

可以在腾讯云/阿里云等平台上领取单域名证书，然后在网关上进行配置 SNI 即可。

## 常见错误

**SSL_connect: Connection reset by peer**

刚领取完证书，配置好 SNI 后，测试请求是没有问题的，但是过一阵子再来测试，发现所有请求都出现该错误，这是由于服务器没有备案的原因，服务器备案后，该错误修复。