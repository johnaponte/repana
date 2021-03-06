# Test helper database
# 20181124 by JJAV
# # # # # # # # # # # #

context("Helper Database")
library(DBI)

# This depends on the configuration is ok and get_con works
test_that("write_log works fine", {

  test_con <- dbConnect(RSQLite::SQLite(),":memory:")
  repana:::write_log(test_con, "iris", format(date()))
  repana:::write_log(test_con, "mtcars", format(date()))
  logs <- dbReadTable(test_con, "log")
  dbDisconnect(test_con)
  rm(test_con)
  expect_equal(nrow(logs), 2)
  expect_equal(logs$table_name , c("iris", "mtcars"))

})


test_that("update_table works fine", {

  test_con <- dbConnect(RSQLite::SQLite(),":memory:")
  update_table(test_con, iris,format(date()))
  update_table(test_con, mtcars,format(date()))
  expect_error(update_table(test_con,borrar, format(date())))
  expect_true(dbExistsTable(test_con,"iris"))
  expect_true(dbExistsTable(test_con,"mtcars"))
  expect_true(dbExistsTable(test_con,"log"))
  logs <- dbReadTable(test_con, "log")
  expect_equal(nrow(logs), 2)
  expect_equal(logs$table_name , c("iris", "mtcars"))
  dbDisconnect(test_con)
  rm(test_con)
})

test_that("clean_database works fine", {
  test_con <- dbConnect(RSQLite::SQLite(),":memory:")
  notables <- dbListTables(test_con)
  update_table(test_con, iris, format(date()))
  update_table(test_con, mtcars, format(date()))
  expect_true(dbExistsTable(test_con,"iris"))
  expect_true(dbExistsTable(test_con,"mtcars"))
  expect_true(dbExistsTable(test_con,"log"))
  capture.output(clean_database(test_con))
  expect_equal(dbListTables(test_con),notables)
  expect_false(dbExistsTable(test_con,"iris"))
  expect_false(dbExistsTable(test_con,"mtcars"))
  expect_false(dbExistsTable(test_con,"log"))
  dbDisconnect(test_con)
  rm(test_con)
})
