# Program test d
# 20181125 by JJAV
# # # # # # # # # # #
#- error = TRUE
library(repana)

# test_con is defined in the script that call this file
stopifnot(exists("test_con", inherits = TRUE))
stopifnot(exists("update_table", inherits = TRUE))
update_table(test_con,"iris")
