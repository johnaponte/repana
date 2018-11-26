# Program test e
# 20181125 by JJAV
# # # # # # # # # # #
#- error = TRUE
library(repana)

con <- get_con()
update_table(con,"iris")
dbDisconnect(con)
rm(con)
