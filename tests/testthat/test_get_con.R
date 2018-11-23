# Test to get the connection
# 20181123 by JJAV
# # # # # # # # # # # # # # #
library(DBI)
context("Test get_con")

# This test will fail on other machines and the location of the driver is
# depends on the instalation and no guarantee it is located in the same place
test_that("get_con works fine" , {
  if (FALSE) {
    testcon <- get_con()
    xiris <- iris
    xiris$Species <- as.character(xiris$Species)
    names(xiris) <- c("a","b","c","d","e")
    dbWriteTable(testcon, "iris", xiris)
    iris2 <- dbReadTable(testcon, "iris")
    expect_equal(xiris, iris2)
    dbDisconnect(testcon)
    rm(testcon)
  }
  else{
    expect_true(TRUE)
  }
})
