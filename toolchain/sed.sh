cd $LFS/sources

tar xvf sed-4.8.tar.xz

cd sed-4.8

./configure --prefix=/usr   \
            --host=$LFS_TGT

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf sed-4.8

echo "Done"