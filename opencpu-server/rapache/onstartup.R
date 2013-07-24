#Disable this for development
.libPaths('/usr/lib/opencpu/library');

#try to disable interactivity
try(.Call(parallel:::C_mc_interactive, FALSE));

#override temp directory
dir.create("/tmp/ocpu-temp", showWarnings = FALSE, recursive = TRUE, mode = "0777");
unixtools::set.tempdir("/tmp/ocpu-temp");
options(configure.vars = paste0("TMPDIR=", tempdir()));
options(rapache=TRUE);

#Load RAppArmor while it is in .libPaths.
getNamespace("RAppArmor")

#Better defer HW limits to later on (eval.secure).
#RAppArmor::rlimit_as(1024^3, verbose=TRUE);
#RAppArmor::rlimit_nproc(50, verbose=TRUE);
#RAppArmor::aa_change_profile("ocpu-main");
