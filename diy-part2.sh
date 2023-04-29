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

# 修改默认主机名
sed -i '/uci commit system/i\uci set system.@system[0].hostname='H66K'' package/lean/default-settings/files/zzz-default-settings
 
# 修改 argon 为默认主题,可根据你喜欢的修改成其他的（不选择那些会自动改变为默认主题的主题才有效果）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Add build date to index page
export orig_version="$(cat "package/lean/default-settings/files/zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')"
sed -i "s/${orig_version}/${orig_version} ($(date +"%Y-%m-%d"))/g" package/lean/default-settings/files/zzz-default-settings

# alist
#git clone https://github.com/sbwml/luci-app-alist package/alist
#rm -rf feeds/packages/lang/golang
#svn export https://github.com/sbwml/packages_lang_golang/branches/19.x feeds/packages/lang/golang

# luci-app-cpufreq
sed -i "s/@arm/@(arm||aarch64)/g" ./feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i "s/"services"/"system"/g" ./feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua

# Add cpufreq
#rm -rf ./feeds/luci/applications/luci-app-cpufreq 
#svn co https://github.com/immortalwrt/luci/trunk/applications/luci-app-cpufreq ./feeds/luci/applications/luci-app-cpufreq
#ln -sf ./feeds/luci/applications/luci-app-cpufreq ./package/feeds/luci/luci-app-cpufreq

# Add OpenClash
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash

#Add luci-app-mosdns
# remove v2ray-geodata package from feeds (openwrt-22.03 & master)
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/applications/luci-app-mosdns/
rm -rf feeds/packages/net/mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# Add luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

#Add luci-theme-design
#rm -rf feeds/luci/themes/luci-theme-design
#git clone https://github.com/gngpp/luci-theme-design.git  package/luci-theme-design
#git clone https://github.com/gngpp/luci-app-design-config.git package/luci-app-design-config

# Clone community packages to package/community
#mkdir package/community
#pushd package/community

# Add luci-aliyundrive-webdav
#rm -rf ../../customfeeds/luci/applications/luci-app-aliyundrive-webdav 
#rm -rf ../../customfeeds/packages/multimedia/aliyundrive-webdav
#svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/aliyundrive-webdav
#svn export https://github.com/messense/aliyundrive-webdav/trunk/openwrt/luci-app-aliyundrive-webdav
#popd

# Add luci-app-vssr <M>
#git clone --depth=1 https://github.com/jerrykuku/lua-maxminddb.git
#git clone --depth=1 https://github.com/jerrykuku/luci-app-vssr

Add subconverter
git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter package/subconverter

#Add rk3568-roc-pc.dts
#wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts -O target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts

# Add luci-app-dockerman
#rm -rf feeds/luci/applications/luci-app-dockerman
#git clone --depth=1 https://github.com/lisaac/luci-app-dockerman package/luci-app-dockerman

./scripts/feeds update -a
./scripts/feeds install -a
