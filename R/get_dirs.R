# Get the dirs wrap
# 20190911 by JJAV
# # # # # # # # # # # #


#' Get the \code{dirs} section of the \code{config.yml} file
#'
#' It is a wrap of \code{config::get("dirs")}.
#'
#' @param file by default the \code{config.yml} file
#' @return a list with the directory entries
#' @export
#' @importFrom config get
get_dirs <- function(file = "config.yml"){
  return(config::get("dirs", file = file))
}
