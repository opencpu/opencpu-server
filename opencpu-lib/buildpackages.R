#Remove local and home libraries to make sure we only depends on base and recommended packages.
#Note: This is still not safe in rpm because base and cran packages are in the same dir.
baselib <- grep("^/usr/lib(64)?/R/library", .libPaths(), value=TRUE)
assign(".lib.loc", baselib, envir=environment(.libPaths));

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

#For Fedora/Redhat
if(is.na(Sys.getenv("NO_APPARMOR", NA))){
	message("Building with AppArmor support")
} else {
	message("Building without AppArmor support")
	options(configure.vars="NO_APPARMOR=1")
}

#Because of dependencies=TRUE, suggested packages sendmailR, RAppArmor and RProtoBuf are also installed.
install.packages(c("opencpu", "unixtools"), dependencies=TRUE, type="source", lib=destdir, contriburl=paste0("file://", sourcedir));
remove.packages("BH", lib = destdir)
