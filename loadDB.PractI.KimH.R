#' PART E: LOAD DATA TO DATABASE
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

# load CSV to data frame
filename <- "restaurant-visits-1-140.csv"
df.orig <- read.csv(filename)

# connect to database
dbFilename <- "visits.db"
dbConnection <- dbConnect(RSQLite::SQLite(), dbFilename)


# populate 'parties' table with filtered data frame
gendersTableData <- df.orig[,13:14]
names(gendersTableData) <- c("party_size", "genders")
gendersTableData <- unique(gendersTableData)
if (nrow(dbGetQuery(dbConnection, "SELECT * FROM parties")) == 0) {
  dbWriteTable(dbConnection, "parties", gendersTableData, overwrite=F, append=T)  
}


# populate 'bills' table with filtered data frame
billsTableData <- df.orig[, c(20:23, 25)]
names(billsTableData) <- c("food_bill", "tip_amount", "discount_applied", 
                           "payment_method", "alcohol_bill")
if (nrow(dbGetQuery(dbConnection, "SELECT * FROM bills")) == 0) {
  dbWriteTable(dbConnection, "bills", billsTableData, overwrite=F, append=T)
}



# populate 'servers' table with filtered data frame
serversTableData <- df.orig[, c(3, 4, 8, 9)]
serversTableData <- serversTableData[serversTableData$ServerEmpID != "NA",]
serversTableData <- na.omit(serversTableData)
serversTableData <- unique(serversTableData)
names(serversTableData) <- c("server_emp_id", "server_name", "server_dob", 
                             "server_tin")
if(nrow(dbGetQuery(dbConnection, "SELECT * FROM servers")) == 0) {
  dbWriteTable(dbConnection, "servers", serversTableData, overwrite=F, append=T)
}


# populate 'restaurants' table
restaurantsTableData <- unique(df.orig[, 2])
print(restaurantsTableData)
if (nrow(dbGetQuery(dbConnection, "SELECT * FROM restaurants")) == 0) {
  for (restaurant in restaurantsTableData) {
    dbExecute(dbConnection, sprintf("INSERT INTO restaurant (name) VALUES (%s)", 
                                    restaurant))
  }
}

# populate 'employments' table


# populate 'customers' table with filtered data frame


# populate 'visits' table

# disconnect from the database
dbDisconnect(dbConnection)
