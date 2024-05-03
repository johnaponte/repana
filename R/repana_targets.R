

#' Create configuration to use targets
#'
#' Create of they do not exist the following directories
#'  - R
#'  - dat
#'  - out
#'
#' If does not exists, create a simplify version of the `_targets.R` script,
#' modify the `.gitignore`. Also add a `config.yml` and a `_template.txt`
#' files.
#'
#' @return NULL
#' @examples
#'  \dontrun{
#' targets_structure()
#' }
#'
#' @export

targets_structure <- function() {
  if (!dir.exists("R")) {
    dir.create("R")
    message("Directory R created")
  }
  if (!dir.exists("rmd")) {
    dir.create("rmd")
    message("Directory rmd created")
  }
  if (!dir.exists("dat")) {
    dir.create("dat")
    message("Directory dat created")
  }
  if (!dir.exists("out")) {
    dir.create("out")
    message("Directory out created")
  }
  if (!file.exists(".gitignore")) {
    cat("\n", file = ".gitignore")
    message("File  .gitignore created")
  }
  if (!any(grepl("_targets", readLines(".gitignore")))) {
    cat("\n#Custom ignores\n", file = ".gitignore", append = T)
    cat("dat\nout\n_targets\n*.Rproj\n",
        file = ".gitignore",
        append = T)
    message("File .gitignore updated")
  }
  if (!file.exists("config.yml")) {
    cat(
'default:
  dirs:
    outdir: out
  clean_before_new_analysis:
    - outdir
  template:
    _template.txt
', file = "config.yml")
    message("File config.txt created")
  }
  if (!file.exists("_template.txt")) {
    cat("#' ---\n#' title:\n#' author:\n#' date: [INSERT DATE]\n#' ---\n",
        file = "_template.txt")
    message("File _template.txt created")
  }
  if (!file.exists("_targets.R")) {
    cat(
      '
# Created by repana_targets().
# This is a simplified version. See details of targets on:
# https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  # For reproducible results uncomment and update seed
  # tar_option_set(seed = 12345),

  # Packages need for the targets
  # packages = c("tidyverse")

  # Add other options
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# List of targets to run
list(
  tar_target(helloworld, cat("Hello World\\n"))
)
',
file = "_targets.R")
message("File _targets.R created")
  }
  invisible()
}
