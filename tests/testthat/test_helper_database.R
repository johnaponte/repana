# Test helper database
# 20181124 by JJAV
# # # # # # # # # # # #

context("Helper Database")
library(DBI)

# This depends on the configuration is ok and get_con works
test_that("write_log works fine", {
  oldop <- options()
  test_con <- dbConnect(RSQLite::SQLite(),":memory:")
  repana:::write_log(test_con, "iris")
  repana:::write_log(test_con, "mtcars")
  logs <- dbReadTable(test_con, "log")
  dbDisconnect(test_con)
  rm(test_con)
  expect_equal(nrow(logs), 2)
  expect_equal(logs$table_name , c("iris", "mtcars"))
  expect_equal(oldop, options())
})


test_that("update_table works fine", {

  test_con <- dbConnect(RSQLite::SQLite(),":memory:")
  update_table(test_con, "iris")
  update_table(test_con, "mtcars")
  expect_error(update_table(test_con,"borrar"), "object 'borrar' not found")
  expect_true(dbExistsTable(test_con,"iris"))
  expect_true(dbExistsTable(test_con,"mtcars"))
  expect_true(dbExistsTable(test_con,"log"))
  logs <- dbReadTable(test_con, "log")
  expect_equal(nrow(logs), 2)
  expect_equal(logs$table_name , c("iris", "mtcars"))
  dbDisconnect(test_con)
  rm(test_con)
})
