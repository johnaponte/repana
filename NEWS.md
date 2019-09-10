*repana 1.10*
  - update table now accept an argument for the name of the table

*repana 1.9*
  - Fix get_con to use a different config.yml if needed

*Version 1.8*

  - Include pool connections and update vignette and documentation
  
*Version 1.7*
  - change the gitignore entry in config.yml to clean_before_new_analysis which
  is more explanatory for non git users.
  This entry is not back compatible any more with the previous config.yml
  
  - The way to specify the database also changes. Now config.yml configure a
  RSQLite in-memory database. This is also not back compatible with previous
  config.yml  

*Version 1.6*

  - Change the way to define the gitignore, as a list instead of an expression
    
*Version 1.5*

  - Fix the duplication of entries in gitignore
  
*Version 1.5*

  - gitignore is now processed based on the names of gitignore entry of
  the config.yml. Previously was a fixed set of directories
  
  - make_structure create directories and subdirectories
  
  
*Version 1.4*

  - New function confirm_libraries()
  
    
*Version 1.3*

  - Include config.yml in .gitignore

  - Change the NEWS to NEWS.md
  
  
*Version 1.2*

  - Improve seeking of Rscript package. Works for Linux and OS
  
  
*Version 1.1* 

  - Include parameter stop to master function

*Version 1.0*

  - Package ready for deployment
