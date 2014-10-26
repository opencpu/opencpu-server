#Read opencpu specific variables and options
if(file.exists("/etc/opencpu/Renviron")) readRenviron("/etc/opencpu/Renviron")
if(file.exists("/etc/opencpu/Rprofile")) source("/etc/opencpu/Rprofile")

#Comment out to for development
.libPaths('/usr/lib/opencpu/library')

#Default locale in apache is "C"
if(grepl("UTF-?8", Sys.getlocale("LC_CTYPE"))){
  cat("Current locale is:", Sys.getlocale("LC_CTYPE"), "\n")
} else {
  Sys.setlocale(category = "LC_ALL", "en_US.UTF-8")
  cat("Setting locale to en_US.UTF-8\n")
}

#Set environment variables
Sys.setenv(LANG = Sys.getlocale("LC_CTYPE"))

#Try to disable interactivity
try(.Call(parallel:::C_mc_interactive, FALSE))

#We use this later
options(rapache = TRUE)

#Load suggested packages while they are in .libPaths()
getNamespace("unixtools")
getNamespace("sendmailR")

#Check if AppArmor is available
tryCatch({
  getNamespace("RAppArmor")
  if(RAppArmor::aa_is_enabled() && identical("unconfined", try(RAppArmor::aa_getcon()$con))){
    options(apparmor = TRUE)
    cat("AppArmor available! Running OpenCPU with security profile and rlimits.\n")
  } else {
    cat("AppArmor not available. Running OpenCPU without security profile but with rlimits.\n")
  }
}, error = function(e){
  options(no_rapparmor = TRUE)
  cat("RAppArmor not installed. Running OpenCPU without security profile or rlimits.\n")
})

#Warm up graphics device
options(bitmapType = "cairo")
svg("/dev/null", width = 11.69, height = 8.27)
plot(1:10)
dev.off()

#Warm up RNG, JSON
invisible(openssl::rand_bytes(1000))
invisible(jsonlite::toJSON(iris))
