# Test targets_structure.R
# By JJAV 20240331
###########################3

# First, let's load the necessary library
library(testthat)
library(tools)

# Now, we'll write the test. Here we want to verify that the function behaves as expected.
test_that("targets_structure creates directories and files if they don't exist", {

  # Let's create a temporary directory to avoid cluttering the working directory
  tmp <- tempdir(check = TRUE)

  # Save current directory
  oldwd <- setwd(tmp)
  on.exit(setwd(oldwd))

    # Now we need to run the targets_structure() function
  targets_structure()

  # We should check if the directories "R", "dat" and "out" have been created
  expect_true(dir.exists("R"))
  expect_true(dir.exists("dat"))
  expect_true(dir.exists("out"))

  # We should also verify that the necessary files are properly created
  expect_true(file.exists(".gitignore"))
  expect_true(any(grepl("_targets", readLines(".gitignore"))))
  expect_true(any(grepl("(dat)|(out)|(_targets)", readLines(".gitignore"))))
  expect_true(file.exists("config.yml"))
  expect_true(file.exists("_template.txt"))
  expect_true(file.exists("_targets.R"))

  # Confirm the files are not change and no errors happens when the
  # command is run again

  md51 <- md5sum(".gitignore")
  md52 <- md5sum("config.yml")
  md53 <- md5sum("_template.txt")
  md54 <- md5sum("_targets.R")

  expect_no_error(targets_structure)
  expect_equal(md5sum(".gitignore"), md51)
  expect_equal(md5sum("config.yml"), md52)
  expect_equal(md5sum("_template.txt"), md53)
  expect_equal(md5sum("_targets.R"), md54)

    # Reset the working directory

})
