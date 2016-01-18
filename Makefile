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
	Rscript ./opencpu-lib/buildpackages.R
	cp ./opencpu-lib/build/opencpu/config/defaults.conf server.conf
	for f in build/*; do bn=$(basename $f); echo "/usr/lib/opencpu/library/$bn /usr/lib/R/library/$bn" >> opencpu-lib.links; done

versionfix:
	( cd opencpu-server ; ./versionfix.sh )
