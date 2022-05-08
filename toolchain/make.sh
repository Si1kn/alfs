cd $LFS/sources

tar xvf make-4.3

cd make-4.3

./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j8

make DESTDIR=$LFS install


cd $LFS/sources

rm -rf make-4.3

echo "Done"