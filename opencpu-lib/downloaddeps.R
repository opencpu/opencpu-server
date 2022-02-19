options(repos = 'https://cran.r-project.org')
deps <- tools::package_dependencies('opencpu', which = 'most')$opencpu
deps <- deps[!deps %in% c('sendmailR', 'R.rsp')]
deps <- c(deps, 'svglite', 'arrow')
deps2 <- tools::package_dependencies(deps, recursive = TRUE)
alldeps <- sort(unique(c(deps, unlist(deps2))))
download.packages(c('opencpu', alldeps), destdir = '.')
