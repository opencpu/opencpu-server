#Remove local and home libraries to make sure we only depends on base and recommended packages.
assign(".lib.loc", c("/usr/lib/R/library"), envir=environment(.libPaths));

#Load Rcpp (to compile httpuv)
#Note that httpuv will not be used by rApache. However it is needed to test-load the package after installation.
#We are no longer including httpuv/RProtobuf/Rcpp
#library(Rcpp, lib.loc="/usr/lib/R/site-library")


#this dir contains the source packages
sourcedir <- file.path(getwd(), "opencpu-lib")
destdir <- file.path(sourcedir, "build");
stopifnot(dir.create(destdir))

#we fist need to create a package index
library(tools);
write_PACKAGES(sourcedir)

#Because of dependencies=TRUE, suggested packages sendmailR, RAppArmor and RProtoBuf are also installed.
install.packages(c("opencpu", "unixtools"), dependencies=TRUE, type="source", lib=destdir, contriburl=paste0("file://", sourcedir));
