# Test to get the connection
# 20181123 by JJAV
# # # # # # # # # # # # # # #
library(DBI)
context("Test get_con")

# This test will fail on other machines and the location of the driver is
# depends on the instalation and no guarantee it is located in the same place
test_that("get_con works fine" , {
  if (TRUE) {
    test_con <- get_con()
  }
  else {
    test_con <- get_con(p_con = dbConnect(RSQLite::SQLite(), ":memory:"))
  }
  xiris <- iris
  xiris$Species <- as.character(xiris$Species)
  names(xiris) <- c("a", "b", "c", "d", "e")
  dbWriteTable(test_con, "iris", xiris, overwrite = T)
  iris2 <- dbReadTable(test_con, "iris")
  expect_equal(xiris, iris2)
  dbDisconnect(test_con)
  rm(test_con)
  if (file.exists("borrar.db"))
    unlink("borrar.db")
})
