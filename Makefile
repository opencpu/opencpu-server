# To force using r-cran-rcpp
# all: versionfix norcpp

#Default is to build included Rcpp
all: versionfix library

#Delete rcpp and build library
norcpp: delrcpp library

delrcpp:
	# Force use of r-cran-rcpp instead
	rm ./opencpu-lib/Rcpp_*.tar.gz

library:
	# Builds the library with R packages.
	sudo sed -i.bak 's/-g//g' /etc/R/Makeconf
	Rscript ./opencpu-lib/buildpackages.R
	sudo mv -f /etc/R/Makeconf.bak /etc/R/Makeconf
	cp ./opencpu-lib/build/opencpu/config/defaults.conf server.conf
	./opencpu-lib/symlinks.sh
	cat debian/opencpu-lib.links

versionfix:
	( cd opencpu-server ; ./versionfix.sh )
