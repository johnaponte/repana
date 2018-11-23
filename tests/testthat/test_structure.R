# Test structure
# 20181123 by JJAV
# # # # # # # # # #

context("Test structures")

test_that("make_structure works fine", {
  curdr  = getwd()
  tmpdr <- tempdir()
  setwd(tmpdr)

  make_structure()

  expect_true(dir.exists("data"))
  expect_true(dir.exists("database"))
  expect_true(dir.exists("handmade"))
  expect_true(dir.exists("logs"))
  expect_true(dir.exists("reports"))

  file.create(file.path('data','test1.txt'))
  file.create(file.path('database','test1.txt'))
  file.create(file.path('handmade','test1.txt'))
  file.create(file.path('logs','test1.txt'))
  file.create(file.path('reports','test1.txt'))

  expect_true(file.exists(file.path('data','test1.txt')))
  expect_true(file.exists(file.path('database','test1.txt')))
  expect_true(file.exists(file.path('handmade','test1.txt')))
  expect_true(file.exists(file.path('logs','test1.txt')))
  expect_true(file.exists(file.path('reports','test1.txt')))

  clean_structure()

  expect_true(file.exists(file.path('data','test1.txt')))
  expect_true(file.exists(file.path('handmade','test1.txt')))
  expect_false(file.exists(file.path('database','test1.txt')))
  expect_false(file.exists(file.path('logs','test1.txt')))
  expect_false(file.exists(file.path('reports','test1.txt')))

  # clean the messs
  setwd(curdr)
})
