# This test the render_report
# 20200130 by JJAV
# # # # # # # # # # # # # # # #

context("Test render_report")
require(rmarkdown)
minpandoc = "1.12.3"

test_that("render_report make a pdf", {
  if (pandoc_available(version = minpandoc)) {
    curdr  = getwd()
    repfile = file.path(curdr, "test_report.Rmd")
    tmpfile <- tempfile()
    dir.create(tmpfile)
    setwd(tmpfile)

    make_structure()
    file.copy(repfile, "test_report.Rmd")
    #render_report("test_report.Rmd", "pdf")
    #expect(file.exists("reports/test_report.pdf"),"PDF file not created")
    render_report("test_report.Rmd", "html")
    expect(file.exists("reports/test_report.html"),"HTML file not created")
    #render_report("test_report.Rmd", "word")
    #expect(file.exists("reports/test_report.docx"), "DOCX file not created")
    render_report("test_report.Rmd","html","./")
    expect(file.exists("test_report.html"), "HTML file not created in other dir")
  }
  else {
    expect(TRUE,"Test not done")
  }
})

test_that("An output file name is provided to the render", {
  if (pandoc_available(version = minpandoc)) {
    curdr  = getwd()
    repfile = file.path(curdr, "test_report.Rmd")
    tmpfile <- tempfile()
    dir.create(tmpfile)
    setwd(tmpfile)

    make_structure()
    file.copy(repfile, "test_report.Rmd")
    render_report("test_report.Rmd", "html", output_file = "borrar.html")
    expect(file.exists("reports/borrar.html"),"HTML file not created")
    expect(!file.exists("borrar.html"), "Original report not deleted")

  }
  else {
    expect(TRUE,"Test not done")
  }

})
