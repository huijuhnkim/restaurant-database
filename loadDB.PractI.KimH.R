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


# populate 'bills' table with filtered data frame


# populate 'servers' table with filtered data frame


# populate 'restaurants' table


# populate 'employments' table


# populate 'customers' table with filtered data frame


# populate 'visits' table

# disconnect from the database
dbDisconnect(dbConnection)
