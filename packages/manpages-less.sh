cd /sources

tar xvf man-pages-5.13.tar.xz

cd man-pages-5.13

make prefix=/usr install

cd /sources

rm -rf man-pages-5.13

echo "Done with man-pages"

cd /sources

tar xvf iana-etc-20220207.tar.gz

cd iana-etc-20220207

cp services protocols /etc

cd /sources

rm -rf iana-etc-20220207

echo "Done iana-etc"

tar xvf glibc-2.35.tar.xz

cd glibc-2.35

patch -Np1 -i ../glibc-2.35-fhs-1.patch

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/usr/lib

make -j8

touch /etc/ld.so.conf

sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make install

sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

mkdir -pv /usr/lib/locale
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f ISO-8859-1 en_GB
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i is_IS -f ISO-8859-1 is_IS
localedef -i is_IS -f UTF-8 is_IS.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f ISO-8859-15 it_IT@euro
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i se_NO -f UTF-8 se_NO.UTF-8
localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
localedef -i zh_TW -f UTF-8 zh_TW.UTF-8

localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../../tzdata2021e.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York

unset ZONEINFO

ln -sfv /usr/share/zoneinfo/Australia/Brisbane /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d

cd /sources

rm -rf glibc-2.35

tar xvf zlib-1.2.11.tar.xz

cd zlib-1.2.11

./configure --prefix=/usr

make -j8

make install

rm -fv /usr/lib/libz.a

cd /sources

rm -rf zlib-1.2.11

echo "Done with zlib"

tar xvf bzip2-1.0.8.tar.gz

cd bzip2-1.0.8

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

make -j8

make PREFIX=/usr install

cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so

cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done

rm -fv /usr/lib/libbz2.a

cd /sources

rm -rf bzip2-1.0.8

echo "Done with bzip2"

tar xvf xz-5.2.5.tar.xz

cd xz-5.2.5

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5

make -j8

make install

cd /sources

rm -rf xz-5.2.5

tar xvf zstd-1.5.2.tar.gz

cd zstd-1.5.2

make -j8

make prefix=/usr install

rm -v /usr/lib/libzstd.a

cd /sources

rm -rf zstd-1.5.2

tar xvf file-5.41.tar.gz

cd file-5.41

./configure --prefix=/usr

make -j8

make install

cd /sources

rm -rf file-5.41

tar xvf readline-8.1.2.tar.gz

cd readline-8.1.2

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.1.2

make SHLIB_LIBS="-lncursesw"

make SHLIB_LIBS="-lncursesw" install

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.1.2

cd /sources

rm -rf readline-8.1.2

tar xvf m4-1.4.19.tar.xz

cd m4-1.4.19

./configure --prefix=/usr

make -j8

make install

cd /sources

rm -rf m4-1.4.19

tar xvf bc-5.2.2.tar.xz

cd bc-5.2.2

CC=gcc ./configure --prefix=/usr -G -O3

make -j8

make install

cd /sources

rm -rf bc-5.2.2

tar xvf flex-2.6.4.tar.gz

cd flex-2.6.4

./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static

make -j8

make install

ln -sv flex /usr/bin/lex

cd /sources

rm -rf flex-2.6.4

tar xvf tcl8.6.12-src.tar.gz

cd tcl8.6.12-src

tar -xf ../tcl8.6.12-html.tar.gz --strip-components=1

SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit)

make -j8

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.3|/usr/lib/tdbc1.1.3|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3|/usr/include|"            \
    -i pkgs/tdbc1.1.3/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.2|/usr/lib/itcl4.2.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.2|/usr/include|"            \
    -i pkgs/itcl4.2.2/itclConfig.sh

unset SRCDIR

make test

make install

chmod -v u+w /usr/lib/libtcl8.6.so

make install-private-headers

ln -sfv tclsh8.6 /usr/bin/tclsh

mv /usr/share/man/man3/{Thread,Tcl_Thread}.3

cd /sources

rm -rf tcl8.6.12-src

tar xvf expect5.45.4.tar.gz

cd expect5.45.4

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make -j8

make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

cd /sources

rm -rf expect5.45.4

tar xvf dejagnu-1.6.3.tar.gz

cd dejagnu-1.6.3

mkdir -v build
cd       build

../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi

make install
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3

cd /sources

rm -rf dejagnu-1.6.3

tar xvf binutils-2.38.tar.xz

cd binutils-2.38

expect -c "spawn ls"

patch -Np1 -i ../binutils-2.38-lto_fix-1.patch

sed -e '/R_386_TLS_LE /i \   || (TYPE) == R_386_TLS_IE \\' \
    -i ./bfd/elfxx-x86.h

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

make -j8 tooldir=/usr

make -k check

make tooldir=/usr install

rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a

cd /sources

rm -rf binutils-2.38

tar xvf gmp-6.2.1.tar.xz

cd gmp-6.2.1

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.1

make -j8

make html

make check 2>&1 | tee gmp-check-log

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html

cd /sources

rm -rf gmp-6.2.1

tar xvf mpfr-4.1.0.tar.xz

cd mpfr-4.1.0

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.1.0

make -j8
make html

make check

make install
make install-html

cd /sources

rm -rf mpfr-4.1.0

tar xvf mpc-1.2.1.tar.gz

cd mpc-1.2.1

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.2.1

make -j8
make html

make install
make install-html

cd /sources

rm -rf mpc-1.2.1

tar xvf attr-2.5.1.tar.gz

cd attr-2.5.1

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.1

make -j8

make install

cd /sources

rm -rf attr-2.5.1

tar xvf acl-2.3.1.tar.xz

cd acl-2.3.1

./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-2.3.1

make -j8

make install

cd /sources

rm -rf acl-2.3.1

tar xvf libcap-2.63.tar.xz

cd libcap-2.63

sed -i '/install -m.*STA/d' libcap/Makefile

make -j8 prefix=/usr lib=lib

make prefix=/usr lib=lib install

cd /sources

rm -rf libcap=2.63

tar xvf shadow-4.11.1.tar.xz

cd shadow-4.11.1

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
    -e 's:/var/spool/mail:/var/mail:'                 \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                \
    -i etc/login.defs

touch /usr/bin/passwd
./configure --sysconfdir=/etc \
            --disable-static  \
            --with-group-name-max-length=32

make -j8 make exec_prefix=/usr install
make -C man install-man

pwconv

grpconv

mkdir -p /etc/default
useradd -D --gid 999

sed -i '/MAIL/s/yes/no/' /etc/default/useradd

cd /sources

rm -rf shadow-4.11.1

tar xvf gcc-11.2.0.tar.xz

cd gcc-11.2.0

sed -e '/static.*SIGSTKSZ/d' \
    -e 's/return kAltStackSize/return SIGSTKSZ * 4/' \
    -i libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -v build
cd       build

../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib

make -j8

ulimit -s 32768

chown -Rv tester .
su tester -c "PATH=$PATH make -k check"

make install
rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/11.2.0/include-fixed/bits/

chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/11.2.0/include{,-fixed}

ln -svr /usr/bin/cpp /usr/lib

ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/11.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

grep -B4 '^ /usr/include' dummy.log

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

grep "/lib.*/libc.so.6 " dummy.log

grep found dummy.log

rm -v dummy.c a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

cd /sources

rm -rf gcc-11.2.0

tar xvf pkg-config-0.29.2.tar.gz

cd pkg-config-0.29.2

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2

make -j8

make install

cd /sources

rm -rf pkg-config-0.29.2

tar xvf ncurses-6.3.tar.gz

cd ncurses-6.3

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec          \
            --with-pkg-config-libdir=/usr/lib/pkgconfig

make -j8

make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.6.3 /usr/lib
rm -v  dest/usr/lib/{libncursesw.so.6.3,libncurses++w.a}
cp -av dest/* /

for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

mkdir -pv      /usr/share/doc/ncurses-6.3
cp -v -R doc/* /usr/share/doc/ncurses-6.3

make distclean
./configure --prefix=/usr    \
            --with-shared    \
            --without-normal \
            --without-debug  \
            --without-cxx-binding \
            --with-abi-version=5
make sources libs
cp -av lib/lib*.so.5* /usr/lib

cd /sources

rm -rf ncurses-6.3

tar xvf sed-4.8.tar.xz

cd sed-4.8

./configure --prefix=/usr

make -j8
make html

make install
install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8

cd /sources

rm -rf sed-4.8

tar xvf psmisc-23.4.tar.xz

cd psmisc-23.4

./configure --prefix=/usr

make -j8

make install

cd /sources

rm -rf psmisc-23.4

tar xvf gettext-0.21.tar.xz

cd gettext-0.21

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.21

make -j8

make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

cd /sources

rm -rf gettext-0.21

tar xvf bison-3.8.2.tar.xz

cd bison-3.8.2

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make -j8

make install

cd /sources

rm -rf bison-3.8.2

tar xvf grep-3.7.tar.xz

cd grep-3.7

./configure --prefix=/usr

make -j8

make install

cd /sources

rm -rf grep=3.7

tar xvf bash-5.1.16.tar.gz

cd bash-5.1.16

./configure --prefix=/usr                      \
            --docdir=/usr/share/doc/bash-5.1.16 \
            --without-bash-malloc              \
            --with-installed-readline

make -j8

make install

exec /usr/bin/bash --login

cd /sources

rm -rf bash-5.1.16

tar xvf libtool-2.4.6.tar.xz

cd libtool-2.4.6

./configure --prefix=/usr

make -j8

make install

rm -fv /usr/lib/libltdl.a

cd /sources

rm -rf libtool-2.4.6

tar xvf gdbm-1.23.tar.gz

cd gdbm-1.23

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make -j8

make install

cd /sources

rm -rf gdbm-1.23

tar xvf gperf-3.1.tar.gz

cd gperf-3.1

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1

make -j8

make install

cd /sources

rm -rf gperf-3.1

tar xvf expat-2.4.6.tar.xz

cd expat-2.4.6

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.4.6

make -j8

make install

install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.4.6

cd /sources

rm -rf expat-2.4.6

tar xvf inetutils-2.2.tar.xz

cd inetutils-2.2

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make -j8

make install

mv -v /usr/{,s}bin/ifconfig

cd /sources

rm -rf inetutils-2.2

tar xvf less-590.tar.gz

cd less-590

./configure --prefix=/usr --sysconfdir=/etc

make -j8

make install

cd /sources

rm -rf less-590

echo "end of this script"
