# NEWS repana 2.2.1

## repana 2.2.1
Production of PDF using the `master` could fail in some systems. The test
of master with PDFs is removed. Producing HTML is more consistent and it is
the recommended way to use `master`

## repana 2.2.0
Add a `targets_structure` function to use the targets system instead
 of the default used by repana.

Add a logo!. Repana package has now a logo

## repana 2.1.0

* Complete vignette to render reports

## repana 2.0.0

* Modified format of `NEWS.md` file to track changes to the package.

* Modify the documentation at package level as requested by CRAN

* Allow to change the template file for a project

* Simplify the template file

* pkgdown is used to create a website for the package in github

* Change the way timestamp is manage. It does not need anymore to include
the start and end within the program.

* Custom YAML tags now control if session info and signature are injected to the
code

* Master now works by default with the spin option.  User format txt option for
only txt output

* Make structure now produce 00_clean.R instead of 01_clean.R

* Simplified pattern manager for programs. Now all programs with format nn_ are
included by default in the list of programs executed by master

* Default db changed from SQLite to duckdb as duckdb have similar functionality,
but is more R friendly and preserver factors and dates (see https://duckdb.org/)

## repana 1.23.2

* Fix a bug if an output_file is included as parameter in the render_function

## repana 1.23.1

* Remove unused dependencies. Check that report is render only if pandoc
is available. Test for render reports only if pandoc is available

* Fix the problem of creating repeated *.Rproj in the .gitignore file

#repana 1.23.0

* The confirm_libraries function has been removed. It was not really
useful and potentially would not work well if many libraries are installed in the
system.

* Messages on the make_structure are now messages and not calls to cat() function.

## repana 1.22.0

* Modification of the version to have three numbers, change author address to submit to CRAN. 

* Modify license. 

* Modify render_report to not delete the output file if the output directory is the same as the directory of the input file.

## repana 1.21

* Small correction in the template

## repana 1.20

* Modify templates. Now only 1 exists which is more friendly for pdf and html render
 and improve the search of Rscript to be windows friendly. 

* DBI is declared as dependent and therefore it is loaded automatically with the package. 

* Master spin is now by default html but a new parameters
  allow to select the type of render. 
  
* Name of reports from rcode is now uniformly called spin instead of SPIN

## repana 1.19

* Modify opening template to have plyr before dplyr and load tidyverse

## repana 1.18

* Modify the templates to have one for the heading and one for the closing part of a SPIN

## repana 1.17

* a master_spin function to run the code as SPINs

## repana 1.16

* New RStudio addin to insert a Template documentation for a SPIN program

## repana 1.15

* Include a function to wrap the render of rmarkdown documents within a program

## repana 1.14

* Include a wrap to writeDataTable. Change as.character to deparse 
to find the name of the data.frame in update_table.

## repana 1.12

* Fix tests for the make_structure now creates 01_clean.R file

## repana 1.11

* Include the get_dirs() function
  
## repana 1.10

* update table now accept an argument for the name of the table

## repana 1.9

*Fix get_con to use a different config.yml if needed

## Version 1.8

* Include pool connections and update vignette and documentation
  
## Version 1.7

* change the gitignore entry in config.yml to clean_before_new_analysis which
  is more explanatory for non git users.
* This entry is not back compatible any more with the previous config.yml
  
* The way to specify the database also changes. Now config.yml configure a
  RSQLite in-memory database. This is also not back compatible with previous
  config.yml  

## Version 1.6

* Change the way to define the gitignore, as a list instead of an expression
    
## Version 1.5

* Fix the duplication of entries in gitignore
  
## Version 1.5

* gitignore is now processed based on the names of gitignore entry of
  the config.yml. Previously was a fixed set of directories
  
* make_structure create directories and subdirectories
  
## Version 1.4*

* New function confirm_libraries()
    
## Version 1.3

* Include config.yml in .gitignore

* Change the NEWS to NEWS.md
  
## Version 1.2

*Improve seeking of Rscript package. Works for Linux and OS
  
## Version 1.1 

*Include parameter stop to master function

## Version 1.0

* Package ready for deployment
