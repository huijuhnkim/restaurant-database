#' PART D: DELETE DATABASE
#' Name: Hui Juhn Kim
#' Current Semester: 2025SU

# install and import required libraries
# TODO: replace with MySQL 
packageVector <- c("RSQLite", "DBI")
for (pkg in packageVector) {
  if (pkg %in% rownames(installed.packages()) == FALSE) {
    install.packages(pkg)
  }
}
library("DBI")
library("RSQLite")

# connect to db
fileName <- "visits.db"
dbConnection <- dbConnect(RSQLite::SQLite(), fileName)

# drop all tables in db
tableList <- dbListTables(dbConnection)
for (table in tableList) {
  if (table != "sqlite_sequence") {
    dropTableStatement = paste0("DROP TABLE ", table)
    dbExecute(dbConnection, dropTableStatement)  
  }
}

# disconnect from database
dbDisconnect(dbConnection)

