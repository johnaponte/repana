## Introduction

There are several utilities in the R ecosystem for reproducible research. The 
package repana (for Reproducible Analysis) help in having a common directory 
structure where to save the files that should be consider part of the main stream
of production, and files that are products of the main stream as well as modified files 
no longer part of the main stream but need to be kept such as re-formatted reports or presentations.

The aspiration of this package is that you can setup an analysis with the `make_structure()` function,
have access to the database using `get_con()` function, have your tables in the 
database documented with the `update_table()` function, and reproduce a complete analysis
by running the  `master()` function

## Directory Structure

The function `make_structure()` creates the following sets of directors

* ___data__ to keep all data sources need to reproduce the analysis. 

* ___functions__ to keep all functions programmed for the analysis
    
* __database__ to keep all secondary datasets and objects
    
* __logs__ to keep the log of the scripts
    
* __reports__ to keep all secondary analysis reports and sheets
    
* __handmade__ to keep all modified files and reports that should be kept
    
    
The information in `_data`, `_functions`, `handmade` as well as the scripts in the root 
directory should be preserved as they are the core of your analysis.
The files in `logs`, `reports` and `database` are created and recreated with 
the scripts. Those are the results of your analysis. The function `clean_structure()`
clean those directories so a new analysis could be re-run without worries that new
and old results are mixed. If you use `git`, the `logs`, `reports` and `database` are
candidates to be excluded from the control version by having them in the `.gitignore` file.
(`make_structure()` take care of create a `.gitignore` if it does not exist or include those
directories if they have not been yet included).

The function `make_structure()` also writes a `config.yml` file to be use by the
`config::get()` function. It contains a the following entries:

__dirs__ to define the directories that make_structure will maintain. It have
the values for `data`, `functions`, `database`, `reports`, `logs`, `handmade`
directories. If you prefer other options than the defaults values you may change
it.

__gitinore__ to define the set of directories that should be cleaned every time you want to repeat
the analysis from zero. This directories are included in the `.gitignore`

__defaultdb__ is written with the parameters for a `SQLite ODBC` driver, It make a guess according
to_the operational system but if not work please check the configuration of you
ODBC driver for SQLite. More examples on `PostgreSQL ODBC ` driver will be provided later

You may add other entries that your analysis may requires. The `config.yml` 
itself should also be included in your `.gitignore` file as it is
something that change from system to system (i.e. driver parameters) so you should
include in the documentation of your analysis what entries should be defined so you
can reproduce the analysis in other machine.

## The configuration of ODBC 

ODBC is used in this package as a way to keep data as well as results in a 
database system. The ODBC source for results could be use by EXCEL files so
you do not need to re-format or modify reports in EXCEL, just refresh data
sources and your tables in EXCEL would reflect you latest analysis. 
The location of the ODBC driver, users and passwords could be different in every system,
but because of having an unique name, the reproduction of the analysis in a different system
would be matter only on change the configuration files. Here we save the configuration
information in the `config.yml` file and read it with the `config` package.
The definition by default is under the  `defaultdb` entry

Example to use `SQLite` memory with a driver in Mac OS

```
default:
 defaultdb:
  driver: '/usr/local/lib/libsqlite3ODBC.dylib'
  database: ':memory:'
```
Example to use `SQLite` with a file

```
default:
 defaultdb:
  driver: '/usr/local/lib/libsqlite3ODBC.dylib'
  database: 'database/analysis.db'
```

Example to use `PostgreSQL`

```
default:
 defaultdb:
  driver: '/Library/ODBC/PostgreSQL/psqlODBCw.so'
  server: localhost
  uid: username
  pwd: pasword
  port: 5432
  database: testdb
```

The configuration can be read with the `get_con()` function


`con <- get_con()`

You may define other configurations an access them with

`con <- get_con("other_conf")`

`get-con` will use `config::get("other_conf")` to read the parameters.


You can define several configuration to use different databases in the same
analysis, but the `defaultdb` will be used by  default for the `update_table()` function.

The function `update_table` will save a data.frame into the database, and will
keep a log in the `log_table` table with the timestamp the file was updated
in the database. The `log_table` keep a record of when was the table included in
the database and a comment that will help to trace the origin. You may include the
date data was obtained or the source of the data.

`update_table(p_con,"iris", "from system)`

## The master function

The `master(pattern, start, logdir, rscript_path)` function execute in a plain vanilla R process each one of the files
identified by the pattern. By default use the pattern `"^[0-9][0-9].*\\.R$"` which include all files like `01_read_data.R`, `02_process_data.R`, `03_analysis_data.R`, `04_make_report.R`
but not `report1.rmd`, `exploratory.R` etc.
Files are run on the order starting from the first but if for any reason you need to omit the first files you may skip them with the `start` parameter.

`logdir` is the directory for the logs, by default `config::get("dirs")$logs`

`rscript_path` is the full path to the `Rscript` program which is at the end the one that process the `R` file. The current default is for a OSx system. But implementation for Linux and Windows will soon be implemented.

The master function use functions from the `processx` package.

## The config.yml file

Here is an example of the `config.yml` created by `make_structure()`

```*.yml
default:
  dirs:
    data: _data
    functions: _functions
    handmade: handmade
    database: database
    reports: reports
    logs: logs
  gitignore: !expr c("database","reports","logs")
  defaultdb:
    driver:  /usr/local/lib/libsqlite3odbc.dylib 
    database: database/results.db
```

## Setup

You may download the package from github. Within R you may use `devtools::install_github()` as:

`devtools::install_github("johnaponte/repana", build_manual = T, build_vignettes = T)`
