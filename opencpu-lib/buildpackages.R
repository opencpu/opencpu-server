#Remove local and home libraries to make sure we only depends on base and recommended packages.
#Note: This is still not safe in rpm because base and cran packages are in the same dir.
baselib <- grep("^/usr/lib(64)?/R/library", .libPaths(), value=TRUE)
assign(".lib.loc", baselib, envir=environment(.libPaths))

#Load Rcpp (to compile httpuv)
#Note that httpuv will not be used by rApache. However it is needed to test-load the package after installation.
#We are no longer including httpuv/RProtobuf/Rcpp
#library(Rcpp, lib.loc="/usr/lib/R/site-library")

#this dir contains the source packages
sourcedir <- file.path(getwd(), "opencpu-lib")
destdir <- file.path(sourcedir, "build")
stopifnot(dir.create(destdir))

#we fist need to create a package index
library(tools);
write_PACKAGES(sourcedir)

# In case of packages installed elsewhere
library(methods)
environment(.libPaths)$.lib.loc = character(0)

#Because of dependencies=TRUE, suggested packages sendmailR, unix and RProtoBuf are also installed.
install.packages("opencpu", dependencies=TRUE, type="source", lib=destdir, contriburl=paste0("file://", sourcedir))

# This causes problems if some packages were pre-installed in the root global libarary
remove.packages("BH", lib = destdir)
