# Parallel make does not work on Centos-7 /ubuntu-18
MAKEFLAGS = -j3

library:
	# Builds the library with R packages.
	mkdir -p "opencpu-lib/.R"
	grep '\-g ' /etc/R/Makeconf | sed 's/-g //g' > "opencpu-lib/.R/Makevars"
	HOME=$(CURDIR)/opencpu-lib Rscript ./opencpu-lib/buildpackages.R
	cp ./opencpu-lib/build/opencpu/config/defaults.conf server.conf
	./opencpu-lib/symlinks.sh
	cat debian/opencpu-lib.links
