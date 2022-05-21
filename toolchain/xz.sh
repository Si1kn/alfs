#!/bin/bash
cd $LFS/sources

tar xvf xz-5.2.5.tar.xz

cd xz-5.2.5

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf xz-5.2.5#!/bin/bash