#!/bin/bash
cd $LFS/sources

tar xvf gzip-1.11.tar.xz

cd gzip-1.11

./configure --prefix=/usr --host=$LFS_TGT

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf gzip-1.11