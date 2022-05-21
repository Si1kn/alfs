cd /sources

tar xvf man-pages-5.13.tar.xz

cd man-pages-5.13

make prefix=/usr install

cd /sources

rm -rf man-pages-5.13

echo "Done"