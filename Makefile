all:
	## Packages are build to the build the packages to the opencpu-admin-library
	## we do this because Rcpp hardcodes the path to the .so file
	Rscript ./opencpu-lib/buildpackages.R

