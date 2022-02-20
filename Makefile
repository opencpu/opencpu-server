# To force using r-cran-rcpp
# all: versionfix norcpp

#Default is to build included Rcpp
all: versionfix library

#Delete rcpp and build library
norcpp: delrcpp library

delrcpp:
	# Force use of r-cran-rcpp instead
	rm ./opencpu-lib/Rcpp_*.tar.gz

export R_MAKEVARS_SITE=./Makevars
export R_MAKEVARS_USER=./Makevars

library:
	# Builds the library with R packages.
	grep '\-g ' /etc/R/Makeconf | sed 's/-g //g' > $(R_MAKEVARS_USER)
	cat $(R_MAKEVARS_USER)
	R_MAKEVARS_USER=$(R_MAKEVARS_USER) Rscript ./opencpu-lib/buildpackages.R
	cp ./opencpu-lib/build/opencpu/config/defaults.conf server.conf
	./opencpu-lib/symlinks.sh
	cat debian/opencpu-lib.links

versionfix:
	( cd opencpu-server ; ./versionfix.sh )
