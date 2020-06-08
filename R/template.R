# Insert a template for an snipet code
# 20200512 by JJAV
# # # # # # # # # # # # # # # # # # # #

#' RStudio addin app to insert a template to the heading part of a snip code
#'
#' @return The template to insert
#' @export
#' @importFrom rstudioapi insertText
insert_open_template <- function(){
  # This function is not included in the unit test
  fpath <- system.file("templates", "template_snip.txt", package="repana")
  txt <- readLines(fpath)
  txt <- paste(txt, collapse  = "\n")
  txt <- gsub("XXXXX", format(Sys.Date()),txt)
  rstudioapi::insertText(txt)
}

#' RStudio addin app to insert a template at the close part of a snip code
#'
#' @return The template to insert
#' @export
#' @importFrom rstudioapi insertText
insert_close_template <- function(){
  # This function is not included in the unit test
  fpath <- system.file("templates", "template_close.txt", package="repana")
  txt <- readLines(fpath)
  txt <- paste(txt, collapse  = "\n")
  txt <- gsub("XXXXX", format(Sys.Date()),txt)
  rstudioapi::insertText(txt)
}
