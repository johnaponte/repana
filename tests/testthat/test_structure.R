# Test structure
# 20181123 by JJAV
# # # # # # # # # #

context("Test structures")

test_that("make_structure works fine", {
  curdr  = getwd()
  tmpfile <- tempfile()
  dir.create(tmpfile)
  setwd(tmpfile)

  make_structure()

  expect_true(dir.exists("_data"))
  expect_true(dir.exists("_functions"))
  expect_true(dir.exists("database"))
  expect_true(dir.exists("handmade"))
  expect_true(dir.exists("logs"))
  expect_true(dir.exists("reports"))

  file.create(file.path('_data','test1.txt'))
  file.create(file.path('_functions','test1.txt'))
  file.create(file.path('database','test1.txt'))
  file.create(file.path('handmade','test1.txt'))
  file.create(file.path('logs','test1.txt'))
  file.create(file.path('reports','test1.txt'))

  expect_true(file.exists(file.path('_data','test1.txt')))
  expect_true(file.exists(file.path('_functions','test1.txt')))
  expect_true(file.exists(file.path('database','test1.txt')))
  expect_true(file.exists(file.path('handmade','test1.txt')))
  expect_true(file.exists(file.path('logs','test1.txt')))
  expect_true(file.exists(file.path('reports','test1.txt')))

  clean_structure()

  expect_true(file.exists(file.path('_data','test1.txt')))
  expect_true(file.exists(file.path('_functions','test1.txt')))
  expect_true(file.exists(file.path('handmade','test1.txt')))
  expect_false(file.exists(file.path('database','test1.txt')))
  expect_false(file.exists(file.path('logs','test1.txt')))
  expect_false(file.exists(file.path('reports','test1.txt')))

  # clean the messs
  setwd(curdr)
  unlink(tmpfile, recursive = T, force = T)
})
