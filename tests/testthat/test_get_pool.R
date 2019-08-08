# Test to get the connection
# 20181123 by JJAV
# # # # # # # # # # # # # # #
library(pool)
context("Test get_con")

test_that("get_con works fine" , {
  curdir  = getwd()
  cat("\nCurrent directory: ", curdir,"\n")
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)

  make_structure()


  test_con <- get_pool()
  xiris <- iris
  xiris$Species <- as.character(xiris$Species)
  names(xiris) <- c("a", "b", "c", "d", "e")
  dbWriteTable(test_con, "iris", xiris, overwrite = T)
  iris2 <- dbReadTable(test_con, "iris")
  expect_equal(xiris, iris2)
  poolClose(test_con)
  rm(test_con)

  # clean the messs
  setwd(curdir)
  unlink(tmpfile, recursive = T, force = T)

})
