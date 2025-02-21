## Version 2.2.1
Production of PDF by repana::master fail in some systems.
The production of PDF requires configuration of Pandoc and rmarkdown. We 
were unable to reproduce the error with the systems available to us.
The production of HTML is consistent and works in all environment so it is the
recommended mode of use of the master function. The test of pdf production in 
testthat has been removed.

── R CMD check results ────────────────────────────────── repana 2.2.1 ────
Duration: 37.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
