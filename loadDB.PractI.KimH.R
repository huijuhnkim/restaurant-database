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