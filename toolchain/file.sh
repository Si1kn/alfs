cd $LFS/sources

tar xvf file-5.41.tar.gz

cd file-5.41

mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file

make DESTDIR=$LFS install


cd $LFS/sources

rm -rf file-5.41

echo "Done"