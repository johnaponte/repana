## Vresion 2.0.0

## R CMD Check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
 
 
## Version 1.24.0

* Modify the documentation at package level as requested by CRAN

* Allow to change the template file for a project

* Vignete with the use of package improved

## Version 1.23.2

* Fix the behavior if the output_file parameter is included in the render_function().


## Version 1.23.1

* The reference to unused libraries has been removed.

* The render report now checks the existence of pandoc. 

* Tests that involve render report also check for the existence of pandoc and are bypassed if not.



## Version 1.23
Thanks to the reviewers. 

* Typos has been corrected. 

* Messages now as messages and not call to the cat() function. 

* The function confirm_libraries has been removed as it really not useful and potentially not work well in systems with
many libraries installed.

## Test environments
* local R installation, R 4.0.4
* ubuntu 16.04 (on travis-ci), R 4.0.4
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
