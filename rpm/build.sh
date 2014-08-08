git clone https://github.com/jeroenooms/opencpu-deb opencpu-1.4.3.99
rm -Rf opencpu-1.4.3.99/.git
tar pczf opencpu-1.4.3.99.tar.gz opencpu-1.4.3.99
mkdir -p ~/rpmbuild/SOURCES
mkdir -p ~/rpmbuild/SPECS
cp -f opencpu-1.4.3.99/rpm/opencpu.spec ~/rpmbuild/SPECS/
mv -f opencpu-1.4.3.99.tar.gz ~/rpmbuild/SOURCES/
rpmbuild -ba ~/rpmbuild/SPECS/opencpu.spec
