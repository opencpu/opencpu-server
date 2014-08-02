#Disable this for development
.libPaths('/usr/lib/opencpu/library');

#default locale in apache is "C"
Sys.setlocale(category='LC_ALL', 'en_US.UTF-8');
Sys.setenv(LANG="en_US.UTF-8")

#try to disable interactivity
try(.Call(parallel:::C_mc_interactive, FALSE));

#we use this later
options(rapache=TRUE);

#Load RAppArmor while it is in .libPaths.
getNamespace("RAppArmor")
getNamespace("unixtools")
getNamespace("sendmailR")

#Check if AppArmor is available
if(RAppArmor::aa_is_enabled() && identical("unconfined", try(RAppArmor::aa_getcon()$con))){
  options(apparmor=TRUE)
} else {
  cat("AppArmor not available! Running OpenCPU without security profile!\n")
}

#warm up graphics device
options(bitmapType = "cairo");
svg("/dev/null", width=11.69, height=8.27)
plot(1:10)
dev.off()
