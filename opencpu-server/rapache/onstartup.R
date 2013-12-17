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
