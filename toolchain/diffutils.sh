cd $LFS/sources

tar xvf diffutils-3.8.tar.xz

cd diffutils-3.8

./configure --prefix=/usr --host=$LFS_TGT

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf diffutils-3.8

echo "Done"