## Version 1.23.01
The reference to unused libraries has been removed.
The render report now checks the existence of pandoc. Tests that involve
render report also chech for the existence of pandoc and are bypassed if not.



## Version 1.23
Thanks to the reviewers. Typos has been corrected. Messages now as messages
and not call to the cat() function. The function confirm_libraries has been
removed as it really not usefull and potentially not work well in systems with
many libraries installed.

## Test environments
* local R installation, R 4.0.4
* ubuntu 16.04 (on travis-ci), R 4.0.4
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
