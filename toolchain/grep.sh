cd $LFS/sources

tar xvf grep-3.7.tar.xz

cd grep-3.7

./configure --prefix=/usr   \
            --host=$LFS_TGT

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf grep-3.7

echo "Done"