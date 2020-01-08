# Test the addDataTable function
# 20191107 by JJAV
# # # # # # # # # # # # # # # # #


context("Test addDataTable")
require(openxlsx)

test_that("addDataTable works fine",{

  options("openxlsx.minWidth" = 6)
  wb <- createWorkbook(title = "Test addDataTable")
  nwb <- addDataTable(wb,iris, rowNames = T, firstActiveCol = 3)
  expect_is(nwb, "Workbook")

})
