#!/bin/bash
cd $LFS/sources

tar xvf linux-5.16.9.tar.xz

cd linux-5.16.9

make mrproper

make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr

cd $LFS/sources

rm -rf linux-5.16.9