#Remove local and home libraries.
assign(".lib.loc", c("/usr/lib/R/site-library", "/usr/lib/R/library"), envir=environment(.libPaths));

#We link to Rcpp from r-cran-rcpp
library(Rcpp, lib.loc="/usr/lib/R/site-library")

#this dir contains the source packages
sourcedir <- file.path(getwd(), "opencpu-lib")
destdir <- file.path(sourcedir, "build");
stopifnot(dir.create(destdir))

#we fist need to create a package index
library(tools);
write_PACKAGES(sourcedir)

#install
install.packages(c("ocpu", "RAppArmor"), dependencies=TRUE, type="source", lib=destdir, contriburl=paste0("file://", sourcedir));
