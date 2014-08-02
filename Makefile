all:
	## Builds the library with R packages.
	## Note that we do not build Rcpp, we use r-cran-rcpp instead.
	Rscript ./opencpu-lib/buildpackages.R
	cp ./opencpu-lib/build/opencpu/config/defaults.conf server.conf
