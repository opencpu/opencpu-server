options(repos = 'https://cloud.r-project.org')
deps <- tools::package_dependencies('opencpu', which = 'most')$opencpu
deps <- deps[!deps %in% c('sendmailR', 'R.rsp')]
deps2 <- tools::package_dependencies(deps, recursive = TRUE)
alldeps <- sort(unique(c(deps, unlist(deps2))))
download.packages(alldeps, destdir = '.')
