#use the system lib
.libPaths("/usr/lib/opencpu/library"); 

#Load RAppArmor while it is in .libPaths.
getNamespace("RAppArmor")
getNamespace("unixtools")

#load opencpu. This triggers setting of proper tempdir, etc. 
options(rapache=TRUE);
library(opencpu)

#update github
opencpu:::updategithub();
