cd $LFS/sources

tar xvf iana-etc-20220207.tar.gz

cd iana-etc-20220207

cp services protocols /etc

cd $LFS/sources

rm -rf iana-etc-20220207

echo "Done"