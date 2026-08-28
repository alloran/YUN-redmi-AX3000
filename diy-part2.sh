#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改openwrt登陆地址,把下面的192.168.5.1修改成你想要的就可以了
sed -i 's/192.168.1.1/192.168.31.1/g' package/base-files/files/bin/config_generate

# 修改主机名字，把Xiaomi-R4A修改你喜欢的就行（不能纯数字或者使用中文）
sed -i '/uci commit system/i\uci set system.@system[0].hostname='redmi-ax3000'' package/lean/default-settings/files/zzz-default-settings

# 版本号里显示一个自己的名字（ababwnq build $(TZ=UTC-8 date "+%Y.%m.%d") @ 这些都是后增加的）
sed -i "s/OpenWrt /ababwbq build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 添加自定义 AmneziaWG 软件包
mkdir -p package/kernel/kmod-amneziawg
cp -r "$GITHUB_WORKSPACE/custom-packages/kmod-amneziawg/"* package/kernel/kmod-amneziawg/
mkdir -p package/network/services/amneziawg-tools
cp -r "$GITHUB_WORKSPACE/custom-packages/amneziawg-tools/"* package/network/services/amneziawg-tools/

# 确保 AmneziaWG 依赖的 crypto / tunnel 内核模块在 ipq50xx 上被编译为模块
# 使用 OpenWrt 的 env/kernel-config 机制覆盖内核配置（优先级最高）
mkdir -p env
cat > env/kernel-config <<'EOF'
CONFIG_CRYPTO_LIB_CHACHA=m
CONFIG_CRYPTO_CHACHA20_NEON=m
CONFIG_CRYPTO_LIB_POLY1305=m
CONFIG_CRYPTO_POLY1305_NEON=m
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
CONFIG_CRYPTO_LIB_CURVE25519=m
CONFIG_CRYPTO_KPP=m
CONFIG_NET_UDP_TUNNEL=m
EOF

echo "[diy-part2] env/kernel-config created:"
cat env/kernel-config

# 兜底：在内核配置生成后强制追加 CONFIG_NET_UDP_TUNNEL=m，避免 kconfig.pl/olddefconfig 把它丢掉
sed -i "/\$(SCRIPT_DIR)\/kconfig.pl 'm+' '+' \$(LINUX_DIR)\/\.config.target \/dev\/null \$(LINUX_DIR)\/\.config.override > \$(LINUX_DIR)\/\.config.set/a\\
\\	echo 'CONFIG_NET_UDP_TUNNEL=m' >> \$(LINUX_DIR)/.config.set\\
\\	echo '[diy-part2] Forced CONFIG_NET_UDP_TUNNEL=m into .config.set'" include/kernel-defaults.mk

