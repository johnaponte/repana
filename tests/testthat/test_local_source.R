# Test for local_source
# 20181124 by JJAV
# # # # # # # # # # # # #

context("Test for local_source")
library(DBI)

test_that("local_source works fine" , {
  test_con <- dbConnect(RSQLite::SQLite(),":memory:")
  dir.create("logs")
  var_c <- "Should not go over the other files"
  local_source("prog_test_a.R", test_con)
  expect_false(exists("var_a", inherits = T))
  local_source("prog_test_b.R", test_con)
  expect_false(exists("var_b", inherits = T))
  local_source("prog_test_c.R", test_con)
  unlink("logs", recursive = TRUE)
  dbDisconnect(test_con)
  rm(test_con)

})
