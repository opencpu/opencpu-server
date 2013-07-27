#Disable this for development
.libPaths('/usr/lib/opencpu/library');

#try to disable interactivity
try(.Call(parallel:::C_mc_interactive, FALSE));

#we use this later
options(rapache=TRUE);

#Load RAppArmor while it is in .libPaths.
getNamespace("RAppArmor")
getNamespace("unixtools")

#Better defer overriding tempdir to later
#dir.create("/tmp/ocpu-temp", showWarnings = FALSE, recursive = TRUE, mode = "0777");
#unixtools::set.tempdir("/tmp/ocpu-temp");

#Better defer HW limits to later on (eval.secure).
#RAppArmor::rlimit_as(1024^3, verbose=TRUE);
#RAppArmor::rlimit_nproc(50, verbose=TRUE);
#RAppArmor::aa_change_profile("ocpu-main");
