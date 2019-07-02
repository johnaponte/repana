# Test for master
# 20190702 by JJAV
# This may fail if make_structure is not ok
# # # # # # # # # # # # # # # # # # # # # #

context("Test for master")

test_that("The pipeline works fine", {
  curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)

  make_structure()
  file.copy(from = dir(curdir, pattern = "^[0-9][0-9].*\\.R$", full.names = T), to = tmpfile)
  capture.output(master())
  expect_true(file.exists("logs/01_prog_test_a.R.log"))
  expect_true(file.exists("logs/02_prog_test_b.R.log"))
  expect_true(file.exists("logs/03_prog_test_c.R.log"))
  expect_true(file.exists("logs/04_prog_test_d.R.log"))
  expect_true(file.exists("logs/master.log"))

  masterfile = read.delim("logs/master.log", stringsAsFactors = FALSE)
  expect_equal(masterfile$comments, c(":-)",":-)","FAIL",":-)"))

  # clean the messs
  setwd(curdir)
  unlink(tmpfile, recursive = T, force = T)

})

test_that("Master respects the arguments", {
  curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)

  make_structure()
  file.copy(from = dir(curdir, pattern = "^[0-9][0-9].*\\.R$", full.names = T), to = tmpfile)
  capture.output(master(start = 4))
  expect_false(file.exists("logs/01_prog_test_a.R.log"))
  expect_false(file.exists("logs/02_prog_test_b.R.log"))
  expect_false(file.exists("logs/03_prog_test_c.R.log"))
  expect_true(file.exists("logs/04_prog_test_d.R.log"))
  expect_true(file.exists("logs/master.log"))

  # clean the messs
  setwd(curdir)
  unlink(tmpfile, recursive = T, force = T)

})

