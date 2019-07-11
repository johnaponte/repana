# Test for master
# 20190702 by JJAV
# This may fail if make_structure is not ok
# # # # # # # # # # # # # # # # # # # # # #

context("Test for master")

test_that("The pipeline works fine", {
  curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  expect_true(file.exists(file.path(curdir,"01_prog_test_a.R")))
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)
  cat("\nTEMPORARY directory: ", tmpfile,"\n")

  make_structure()
  file.copy(from = dir(curdir, pattern = "^[0-9][0-9].*\\.R$", full.names = T), to = tmpfile)

  dfres <- master()
  expect_true(file.exists("logs/01_prog_test_a.R.log"))
  expect_true(file.exists("logs/02_prog_test_b.R.log"))
  expect_true(file.exists("logs/03_prog_test_c.R.log"))
  expect_true(file.exists("logs/04_prog_test_d.R.log"))
  expect_true(file.exists("logs/master.log"))
print(dfres)
  masterfile = read.delim("logs/master.log", stringsAsFactors = FALSE)
  expect_equal(masterfile$comments, c(":-)",":-)","FAIL",":-)"))

})

test_that("Master respects the start & stop arguments", {
  curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)

  make_structure()
  expect_true(file.exists(file.path(curdir,"01_prog_test_a.R")))
  file.copy(from = dir(curdir, pattern = "^[0-9][0-9].*\\.R$", full.names = T), to = tmpfile)
  capture.output(master(start = 2, stop = 3))
  expect_false(file.exists("logs/01_prog_test_a.R.log"))
  expect_true(file.exists("logs/02_prog_test_b.R.log"))
  expect_true(file.exists("logs/03_prog_test_c.R.log"))
  expect_false(file.exists("logs/04_prog_test_d.R.log"))
  expect_true(file.exists("logs/master.log"))
})

