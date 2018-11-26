# Program test B
# 20181124 by JJAV
# # # # # # # # # # #

var_a <- "AAA"
# Variable defined in prog_test_a
stopifnot(!exists("var_b", inherits = TRUE))
# Variable defined in the environment that called local_source
#stopifnot(!exists("var_c", inherits = TRUE))
