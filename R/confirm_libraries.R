# This checks for the libraries used during the analysis
# 20190722 by JJAV
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#' Confirm if all libraries are installed
#'
#' Search all R and Rmd files for the keyword library(  or ::
#' and check if the library is installed.
#'
#' @return invisible a data.frame with all the libraries found
#' @importFrom plyr ldply
#' @importFrom magrittr %>%
#' @importFrom dplyr select
#' @importFrom dplyr filter
#' @importFrom utils installed.packages
#' @author John J. Aponte
#' @examples
#' confirm_libraries()
#' @export
confirm_libraries <- function() {
  rfiles <-
    dir("." ,
        pattern = "(\\.R$)|(\\.Rmd$)",
        recursive = T,
        full.names = T)
  libfiles <- plyr::ldply(rfiles, function(x) {
    textfile <- readLines(x, warn = FALSE)
    lwithlibrary <-
      grep("library\\(.*)", textfile, value = T) %>%
      gsub("library\\(|)", "", .)
    lwithcolon <-
      grep("*::*", textfile, value = T)  %>%
      regmatches(., regexpr("\\w*::", .)) %>%
      gsub("::", "", .)
    lall <-
      c(lwithcolon, lwithlibrary) %>%
      unique()
    linstalled <-
      ifelse(lall %in% rownames(installed.packages()),
             "installed",
             "MISSING")
    data.frame(
      dirname = rep(dirname(x), length(lall)),
      basename = rep(basename(x), length(lall)),
      libraries = lall,
      installed = linstalled,
      stringsAsFactors = FALSE
    )
  })
  mlibs <-
    libfiles %>% filter(installed == "MISSING") %>% select(libraries)
  if (nrow(mlibs) == 0) {
    cat("ALL libraries installed \n")
  }
  else {
    cat("Following libraries are not installed:\n")
    cat(paste(sort(unique(
      mlibs$libraries
    )), collapse = ", "), "\n")
  }
  return(invisible(libfiles))
}


