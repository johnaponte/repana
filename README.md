# Introduction to repana (Reproducble Analysis in R)

Reproducible research is a crucial aspect of the scientific process, especially in data science. It ensures that the same inputs, including data, libraries, and user programs, consistently produce the same results or artifacts. This not only enhances the credibility of research but also streamlines collaboration and makes it easier to verify and build upon previous work. There are several options in R to achieve reproducible research and repanafacilitates the pursuit of reproducible research.

## What is Repana?

Repana is an R package designed to simplify the process of conducting reproducible research. It provides a structured framework for managing your R projects, ensuring that your research artifacts, such as new datasets, tables, figures, listings, and reports, remain consistent across runs. Repana's opinionated structure can be customized to fit your specific needs, but its core principles revolve around the concept of reproducibility.

## The Core Features of Repana

1. **Structured Workflow:**
   Repana enforces an opinionated structure for your project. The function `make_strucutre()` helps with the creation of this structure. Standardize project structures and documentation help to understand the workflow and facilitates collaboration
   
2. **Master Function:**
   The heart of Repana is the `master()` function. This function executes programs in the working directory whose names start with two numbers and an underscore (e.g., `00_xxx`, `01_xxx`, `02_xxx`, etc.) in the intended order. This automated execution ensures that your research workflow is standardized and can be easily reproduced. The R scripts are compiled as scripts to a notebook using rmarkdown. This help the programmer to concentrate on the programming while allow to document the code and produce HTML, PDF or MS Word files to document the execution of the program. Each program executed in an independent environment which prevent unintended interference between programs, ensuring that your research remains truly reproducible

3. **Artifact Management:**
   Repana provides a function `clean_structure()`to be included in the first program (usually `00_clean.R`) to delete and recreate the directories where artifacts are saved. This action guarantees that the artifacts presented in the directories are created by the current run, eliminating the risk of using outdated versions from previous runs.

5. **Database Configuration:**
   In the realm of data science, databases are often a crucial component of research. Repana allows you to configure databases within your project, making it easier to manage and access data sources.

6. **Git Friendliness:**
   Repana is GIT-friendly. It helps you keep track of source information and user programs without including the generated artifacts in the GIT repository. This ensures that your version control system focuses on the essential aspects of your research.

## How to Get Started with Repana

To get started with Repana, follow these steps:

1. **Installation:** You can install Repana from CRAN using `install.packages("Repana")` or if you want to use the developing version from git-hub
`devtools::install_github("johnaponte/repana", build_manual = T, build_vignettes = T)`

2. **Project Setup:** Create a new project and use `repana::make_structure()` to construct the opinionated structure required by Repana. Customize it as needed to fit your research requirements modifying the `config.yml`file.

3. **Programming:** Write your R programs, ensuring that they follow the naming conventions (e.g., `00_xxx`, `01_xxx`, etc.). If using the RStudio IDE use the `Repana insert template` addin to include a consistent head documentation for your project. Options in the head template allows to include a timestamp and signature to the created document and the packages used in the execution of each program.

4. **Artifact Management:** Ensure your first program include the  `clean_stucture()`function. By default, the make_structure() function creates one for you in the `00_clean.R`. The execution of `clean_structure` will re-create all the directories where dependencies are saved. This directories are defined in the `config.yml` file

5. **Execute Programs:** Utilize the `master()` function to run your programs in the intended order, keeping your research consistent and reproducible. By default `master()` executes all programs in the default directory that follow the naming convention, but you may use the start and stop options to execute only a set of the programs. You may also use the `format` option to modify the output from HTML to PDF or MS_DOS

6. **Documentation and Collaboration:** Document your work using the provided templates and collaborate seamlessly with your team or the broader research community.

For more information see:

- Creating a Repana structure
- Database configuration
- Modifying the template
- Creating reports
