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

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

#替换argon主题
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/luci-app-argon-config
#rm -rf feeds/luci/themes/luci-theme-argon
#rm -rf feeds/luci/themes/luci-theme-design
#git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git feeds/luci/themes/luci-theme-argon
#git clone https://github.com/gngpp/luci-theme-design.git feeds/luci/themes/luci-theme-design
#rm -rf feeds/luci/applications/luci-app-argon-config
#rm -rf feeds/luci/applications/luci-app-design-config
#git clone -b 18.06 https://github.com/jerrykuku/luci-app-argon-config.git feeds/luci/applications/luci-app-argon-config
#git clone https://github.com/gngpp/luci-app-design-config.git feeds/luci/applications/luci-app-design-config

#更换diskman
#rm -rf feeds/luci/applications/luci-app-diskman


#拉取OpenClash
git clone -b master --single-branch --filter=blob:none https://github.com/vernesong/OpenClash.git package/luci-app-openclash

#拉取adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome package/luci-app-adguardhome

#拉取wechatpush
git clone https://github.com/tty228/luci-app-wechatpush package/luci-app-wechatpush

#设置默认主题
#sed -i "s/luci-theme-bootstrap/luci-theme-argon/g" feeds/luci/collections/luci/Makefile
#sed -i "s/luci-theme-bootstrap/luci-theme-design/g" feeds/luci/collections/luci/Makefile

#设置内核版本
#sed -i 's/KERNEL_PATCHVER:=6.1/KERNEL_PATCHVER:=6.6/g' target/linux/x86/Makefile

#将nlbwmon从服务目录移动到菜单栏
sed -i -e '/"path": "admin\/services\/nlbw\/display"/d' -e 's/services\///g' -e 's/"type": "alias"/"type": "firstchild"/' package/feeds/luci/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's|admin/services/nlbw/backup|admin/nlbw/backup|g' package/feeds/luci/luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

#将clash内核、TUN内核、Meta内核编译进目录
mkdir -p files/etc/openclash/core
curl -L https://raw.githubusercontent.com/vernesong/OpenClash/core/master/dev/clash-linux-amd64.tar.gz | tar -xz -C /tmp
mv /tmp/clash files/etc/openclash/core/clash
chmod 0755 files/etc/openclash/core/clash
curl -L https://raw.githubusercontent.com/vernesong/OpenClash/core/master/premium/clash-linux-amd64-2023.08.17-13-gdcc8d87.gz | gunzip -c > /tmp/clash_tun
mv /tmp/clash_tun files/etc/openclash/core/clash_tun
chmod 0755 files/etc/openclash/core/clash_tun
curl -L https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-amd64.tar.gz | tar -xz -C /tmp
mv /tmp/clash files/etc/openclash/core/clash_meta
chmod 0755 files/etc/openclash/core/clash_meta

#将AdGuardHome核心文件编译进目录
curl -s https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest \
| grep "browser_download_url.*AdGuardHome_linux_amd64.tar.gz" \
| cut -d : -f 2,3 \
| tr -d \" \
| xargs curl -L -o /tmp/AdGuardHome_linux_amd64.tar.gz && \
tar -xzvf /tmp/AdGuardHome_linux_amd64.tar.gz -C /tmp/ --strip-components=1 && \
mkdir -p files/usr/bin/AdGuardHome && \
mv /tmp/AdGuardHome/AdGuardHome files/usr/bin/AdGuardHome/
chmod 0755 files/usr/bin/AdGuardHome/AdGuardHome
