#!/bin/bash
cd $LFS/sources

tar xvf example

cd example

sed '6009s/$add_dir//' -i ltmain.sh

mkdir -v build
cd       build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf example