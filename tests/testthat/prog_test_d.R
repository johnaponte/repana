# Program test d
# 20181125 by JJAV
# # # # # # # # # # #
#- error = TRUE
library(repana)

stopifnot(exists("p_con", inherits = TRUE))
stopifnot(exists("update_table", inherits = TRUE))
update_table(p_con,"iris")
