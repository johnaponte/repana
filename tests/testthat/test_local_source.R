# Test for local_source
# 20181124 by JJAV
# # # # # # # # # # # # #

context("Test for local_source")
library(DBI)

test_that("local_source works fine" , {
  if (!dir.exists("logs"))
    dir.create("logs")
  var_c <- "Should not go over the other files"
  local_source("prog_test_a.R")
  expect_false(exists("var_a", inherits = T))
  expect_true(geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  expect_true(file.exists("logs/prog_test_a.html"))
  local_source("prog_test_b.R")
  expect_false(exists("var_b", inherits = T))
  expect_true(file.exists("logs/prog_test_b.html"))
  expect_true(geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  local_source("prog_test_c.R")
  expect_true(geterrmessage() != "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  expect_true(file.exists("logs/prog_test_c.html"))
  local_source("prog_test_a.R")
  expect_true(geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  unlink("logs", recursive = TRUE)
})


test_that("db_local_source works fine" , {
  test_con <- dbConnect(RSQLite::SQLite(),":memory:")
  if (!dir.exists("logs"))
    dir.create("logs")
  var_c <- "Should not go over the other files"
  db_local_source(test_con, "prog_test_a.R")
  expect_false(exists("var_a", inherits = T))
  expect_true(geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  expect_true(file.exists("logs/prog_test_a.html"))
  db_local_source(test_con, "prog_test_b.R")
  expect_false(exists("var_b", inherits = T))
  expect_true(file.exists("logs/prog_test_b.html"))
  expect_true(geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  db_local_source(test_con, "prog_test_c.R")
  expect_true(geterrmessage() != "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  expect_true(file.exists("logs/prog_test_c.html"))
  db_local_source(test_con, "prog_test_a.R")
  expect_true(geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  db_local_source(test_con, "prog_test_d.R")
  expect_true(geterrmessage() == "Error in try(stop(\".HaPPyEnD\"), silent = TRUE) : .HaPPyEnD\n")
  restables <- dbListTables(test_con)
  expect_equal(restables, c("iris","log_script","log_table"))
  logscript <- dbReadTable(test_con,"log_script")
  expect_equal(nrow(logscript), 5)
  expect_equal(logscript$happy_end,c(":-)",":-)",":-O",":-)",":-)"))
  dbDisconnect(test_con)
  rm(test_con)
  unlink("logs", recursive = TRUE)
})
