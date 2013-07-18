#because .libPaths() only appends paths, doesn't replace anything.
setLibPaths <- function(newlibs){
	checkfordir <- function(path){
		return(isTRUE(file.info(path)$isdir));
	}	
	newlibs <- newlibs[sapply(newlibs, checkfordir)]
	assign(".lib.loc", newlibs, envir=environment(.libPaths));
}

#removes all lib paths except for base.
setLibPaths("/usr/lib/R/library")

#install in expected dir
destdir <- ("/usr/lib/opencpu/library/")

#this dir contains the source packages
sourcedir <- paste("file://", getwd(), "/opencpu-lib/", sep="")

#we fist need to create a package index
library(utils);
write_PACKAGES(sourcedir)

#just in case
dir.create(destdir, showWarnings=FALSE)

#install
install.packages(c("ocpu"), type="source", lib=destdir, contriburl=sourcedir)
