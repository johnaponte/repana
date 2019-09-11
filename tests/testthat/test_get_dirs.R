# Thest the get_dirs
# 20190911 by JJAV
# # # # # # # # # # # #
context("Test get_dirs")

test_that("get_dirs works fine" , {
  curdir  = getwd()
  #cat("\nCurrent directory: ", curdir,"\n")
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)

  make_structure()
  dirs <- get_dirs()
  expect_type(dirs,"list")
  # clean the messs
  setwd(curdir)
  unlink(tmpfile, recursive = T, force = T)

})
