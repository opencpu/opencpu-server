#CRAN packages
update.packages(lib.loc = "/tmp/ocpu-www-data/cran_library/", repos = "http://cran.r-project.org", ask = FALSE, checkBuilt=TRUE);
if(length(list.files("/tmp/ocpu-www-data/cran_library/"))){
	system2("touch", "/tmp/ocpu-www-data/cran_library/*");
}
