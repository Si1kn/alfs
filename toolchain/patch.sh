cd $LFS/sources

tar xvf patch-2.7.6.tar.xz

cd patch-2.7.6

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf patch-2.7.6

echo "Done"