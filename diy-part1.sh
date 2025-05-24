#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# 取消插件注释
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 添加插件源码
# sed -i '$a src-git ddnsto https://github.com/linkease/ddnsto-openwrt' feeds.conf.default
# sed -i '$a src-git adguardhome https://github.com/rufengsuixing/luci-app-adguardhome' feeds.conf.default
# sed -i '$a src-git dnsfilter https://github.com/garypang13/luci-app-dnsfilter' feeds.conf.default
# 添加 helloworld (包含ssr-plus)
sed -i '$a src-git helloworld https://github.com/fw876/helloworld.git'  feeds.conf.default  
#sed -i '$a src-git argon https://github.com/jerrykuku/luci-theme-argon.git'  feeds.conf.default
#sed -i '$a src-git ua2f https://github.com/Zxilly/UA2F.git'  feeds.conf.default
# sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
# passwall依赖
# sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
#sed -i 's/CONFIG_PACKAGE_xray-core=y/# CONFIG_PACKAGE_xray-core is not set/' .config
### 修改主题文件
