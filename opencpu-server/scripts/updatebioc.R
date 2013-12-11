#BIOC packages
source("http://bioconductor.org/biocLite.R");
update.packages(lib.loc="/tmp/ocpu-www-data/bioc_library/", repos=biocinstallRepos(), ask = FALSE, checkBuilt=TRUE);
if(length(list.files("/tmp/ocpu-www-data/bioc_library/"))){
	system2("touch", "/tmp/ocpu-www-data/bioc_library/*");
}
