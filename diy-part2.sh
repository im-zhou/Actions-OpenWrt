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

#拉取wrtbwmon
git clone https://github.com/brvphoenix/wrtbwmon.git package/wrtbwmon

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

#修改sysguarde备份列表
cat <<EOF > files/etc/sysupgrade.conf
## This file contains files and directories that should
## be preserved during an upgrade.

# /etc/example.conf
# /etc/openvpn/
/etc/AdGuardHome.yaml
/usr/bin/AdGuardHome/
/www/luci-static/argon/background/
/usr/share/wechatpush/api/OpenWrt.jpg
/root/backup_openwrt.sh
/root/sshpass
EOF

chmod 0644 files/etc/sysupgrade.conf

#kms激活配置文件
cat << EOF >> files/etc/vlmcsd.ini
# ePID/HwId设置为Windows显式
;Windows = 06401-00206-471-111111-03-1033-17763.0000-2822018 / 01 02 03 04 05 06 07 08

# ePID设置为Office2010（包含Visio和Project）显式
;Office2010 = 06401-00096-199-222222-03-1033-17763.0000-2822018

# ePID/HwId设置为Office2013（包含Visio和Project）显式
;Office2013 = 06401-00206-234-333333-03-1033-17763.0000-2822018 / 01 02 03 04 05 06 07 08

# ePID/HwId设置为Office2016（包含Visio和Project）显式
;Office2016 = 06401-00206-437-444444-03-1033-17763.0000-2822018 / 01 02 03 04 05 06 07 08

# ePID/HwId设置为Office2019（包含Visio和Project）显式
;Office2019 = 06401-00206-666-666666-03-1033-17763.0000-2822018 / 01 02 03 04 05 06 07 08

# ePID/HwId设置为Windows中国政府版 (Enterprise G/GN) 显式
;WinChinaGov = 06401-03858-000-555555-03-1033-17763.0000-2822018 / 01 02 03 04 05 06 07 08

# 使用自定义TCP端口
;Port = 1688

# 监听所有IPv4地址（默认端口1688）
;Listen = 0.0.0.0:1688

# 监听所有IPv6地址（默认端口1688）
;Listen = [::]:1688

# 程序启动时随机ePIDs（只有那些未显式指定的）
;RandomizationLevel = 1

# 在ePIDs中使用特定区域 (1033 = 美国英语)，即使ePID是随机的
;LCID = 1033

# 设置最多4个同时工作（分叉进程或线程）
;MaxWorkers = 4

# 闲置30秒后断开用户
;ConnectionTimeout = 30

# 每次请求后立即断开客户端
;DisconnectClientsImmediately = yes

# 写一个pid文件（包含vlmcsd的进程ID的文件）
;PidFile = /var/run/vlmcsd.pid

# 写日志到/var/log/vlmcsd.log
;LogFile = /var/log/vlmcsd.log

# 创建详细日志
;LogVerbose = true

# 设置激活间隔2小时
;ActivationInterval = 2h

# 设置更新间隔7天
;RenewalInterval = 7d

# 运行程序的用户为vlmcsduser
;user = vlmcsduser

# 运行程序的组为vlmcsdgroup
;group = vlmcsdgroup 

# 禁用或启用RPC的NDR64传输语法（默认启用）
;UseNDR64 = true

# 禁用或启用RPC的绑定时间特性协商（默认启用）
;UseBTFN = true
EOF

chmod 0755 files/etc/vlmcsd.ini
