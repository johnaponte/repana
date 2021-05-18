# Test for master
# 20190702 by JJAV
# This may fail if make_structure is not ok
# # # # # # # # # # # # # # # # # # # # # #

context("Test for master spin")
require(rmarkdown)
minpandoc= "1.12.3"

test_that("The pipeline works fine", {
  if (pandoc_available(version = minpandoc)) {
    curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  expect_true(file.exists(file.path(curdir,"02_prog_a.R")))
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)
  cat("\nTEMPORARY directory: ", tmpfile,"\n")

  make_structure()
  file.copy(from = dir(curdir, pattern = "^[0-9][0-9].*\\.R$", full.names = T), to = tmpfile)

  dfres <- master_spin(format = "pdf")
  expect_true(file.exists("logs/01_clean.pdf"))
  expect_true(file.exists("logs/02_prog_a.pdf"))
  expect_true(file.exists("logs/03_prog_b.pdf"))
  expect_false(file.exists("logs/04_prog_c.pdf"))
  expect_true(file.exists("logs/05_prog_d.pdf"))
  expect_true(file.exists("logs/master.log"))
print(dfres)
  masterfile = read.delim("logs/master.log", stringsAsFactors = FALSE)
  expect_equal(masterfile$comments, c(":-)",":-)",":-)","FAIL",":-)"))
  }
  else{
    expect(TRUE,"Test not done")
  }
})


test_that("The pipeline works fine with html", {
  if (pandoc_available(version = minpandoc)) {

  curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  expect_true(file.exists(file.path(curdir,"02_prog_a.R")))
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)
  cat("\nTEMPORARY directory: ", tmpfile,"\n")

  make_structure()
  file.copy(from = dir(curdir, pattern = "^[0-9][0-9].*\\.R$", full.names = T), to = tmpfile)

  dfres <- master_spin(format = "html")
  expect_true(file.exists("logs/01_clean.html"))
  expect_true(file.exists("logs/02_prog_a.html"))
  expect_true(file.exists("logs/03_prog_b.html"))
  expect_false(file.exists("logs/04_prog_c.html"))
  expect_true(file.exists("logs/05_prog_d.html"))
  expect_true(file.exists("logs/master.log"))
  print(dfres)
  masterfile = read.delim("logs/master.log", stringsAsFactors = FALSE)
  expect_equal(masterfile$comments, c(":-)",":-)",":-)","FAIL",":-)"))
  }
  else {
    expect(TRUE, "Test not done")
  }
})

test_that("Master respects the start & stop arguments", {
  if (pandoc_available(version = minpandoc)) {
    curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)

  make_structure()
  expect_true(file.exists(file.path(curdir,"02_prog_a.R")))
  file.copy(from = dir(curdir, pattern = "^[0-9][0-9].*\\.R$", full.names = T), to = tmpfile)
  capture.output(master(start = 3, stop = 4))
  expect_false(file.exists("logs/02_prog_a.R.log"))
  expect_true(file.exists("logs/03_prog_b.R.log"))
  expect_true(file.exists("logs/04_prog_c.R.log"))
  expect_false(file.exists("logs/05_prog_d.R.log"))
  expect_true(file.exists("logs/master.log"))
  }
  else{
    expect(TRUE, "Test not done")
  }
})

