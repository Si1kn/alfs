cd $LFS/sources

tar xvf gawk-5.1.1.tar.xz

cd gawk-5.1.1

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j8

make DESTDIR=$LFS install

cd $LFS/sources

rm -rf gawk-5.1.1

echo "Done"