#Run as root
.libPaths("/usr/lib/opencpu/library")
library(RAppArmor)
library(unixtools)

setgid(33)
setuid("www-data")
options(rapache=TRUE)

library(opencpu)
opencpu:::loadconfigs()
cranpath <- "/tmp/ocpu-www-data/cran_library"
setwd(tempdir())
aa_change_profile("opencpu-main")

#build from scratch. Make sure to get latest version of dependencies as well.
all <- available.packages()
opencpu:::setLibPaths(c(cranpath, "/usr/lib/opencpu/library", "/usr/lib/R/library"))
install.packages(row.names(all), lib=cranpath, Ncpus=parallel::detectCores())

#try again one by one, using r-cran packages
opencpu:::setLibPaths(c(cranpath, "/usr/lib/opencpu/library", "/usr/lib/R/library", "/usr/lib/R/site-library"))
new <- new.packages(cranlib)
install.packages(new)
