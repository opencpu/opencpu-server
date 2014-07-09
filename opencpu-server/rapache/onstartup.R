#Disable this for development
.libPaths('/usr/lib/opencpu/library');

#default locale in apache is "C"
Sys.setlocale(category='LC_ALL', 'en_US.UTF-8');

#try to disable interactivity
try(.Call(parallel:::C_mc_interactive, FALSE));

#we use this later
options(rapache=TRUE);

#Load RAppArmor while it is in .libPaths.
getNamespace("RAppArmor")
getNamespace("unixtools")
getNamespace("sendmailR")

#Check if AppArmor is working
if(is(try(RAppArmor::eval.secure(1+1, profile="opencpu-main"), silent=TRUE), "try-error")){
  cat("AppArmor not available! Running OpenCPU without security profile!\n")
} else {
  options(apparmor=TRUE)
}

#warm up graphics device
options(bitmapType = "cairo");
svg("/dev/null", width=11.69, height=8.27)
plot(1:10)
dev.off()
