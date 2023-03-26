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

# Add openclash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash package/luci-app-openclash

# Add luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config

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

# Add ServerChan
#git clone --depth=1 https://github.com/tty228/luci-app-serverchan feeds/luci/applications/luci-app-serverchan

# Add subconverter
#git clone --depth=1 https://github.com/tindy2013/openwrt-subconverter

#Add rk3568-roc-pc.dts
#wget https://raw.githubusercontent.com/coolsnowwolf/lede/master/target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts -O target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts

# Add luci-app-dockerman
#rm -rf feeds/luci/applications/luci-app-dockerman
#git clone --depth=1 https://github.com/lisaac/luci-app-dockerman package/luci-app-dockerman

# Test kernel 5.15
sed -i 's/5.4/6.1/g' ./target/linux/rockchip/Makefile
rm -rf target/linux/rockchip/image/armv8.mk
cp -f $GITHUB_WORKSPACE/armv8.mk target/linux/rockchip/image/armv8.mk
cp -f $GITHUB_WORKSPACE/999-fuck-rockchip-pcie.patch target/linux/rockchip/patches-6.1/999-fuck-rockchip-pcie.patch

./scripts/feeds update -a
./scripts/feeds install -a
