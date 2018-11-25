# Program test A
# 20181124 by JJAV
# # # # # # # # # # #

var_a <- "AA"
var_b <- "BB"
# Variable defined in environment that call this program
stopifnot(!exists("var_c",  inherits = TRUE))
# The connection should exists
stopifnot(exists("p_con"))
