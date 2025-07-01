#' PART C: REALIZE DATABASE
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

# connect to database
filename <- "RestaurantVisits.db"
dbConnection <- dbConnect(RSQLite::SQLite(), filename)

# create servers table
createServersTableStatement <- "
  CREATE TABLE IF NOT EXISTS servers (
    server_emp_id INTEGER PRIMARY KEY,
    server_name TEXT NOT NULL DEFAULT 'N/A',
    hired_start_date DATE NOT NULL DEFAULT '0000-00-00',
    hired_end_date DATE NOT NULL DEFAULT '9999-99-99',
    hourly_rate NUMERIC(10,2) NOT NULL DEFAULT 0,
    server_dob DATE,
    server_tin TEXT
  );
"
dbExecute(dbConnection, createServersTableStatement)

# create customers table
createCustomersTableStatement <- "
CREATE TABLE IF NOT EXISTS customers (
  phone_number TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  is_loyalty_member INTEGER CHECK (is_loyalty_member IN (0, 1))
);
"
dbExecute(dbConnection, createCustomersTableStatement)

# create bills table
createBillsTableStatement <- "
CREATE TABLE IF NOT EXISTS bills (
  bill_id INTEGER PRIMARY KEY AUTOINCREMENT,
  food_bill NUMERIC(10,2) NOT NULL,
  alcohol_bill NUMERIC(10,2) NOT NULL,
  tip_amount NUMERIC(10,2) NOT NULL,
  discount_applied NUMERIC(10,2) NOT NULL,
  payment_method TEXT NOT NULL
);
"
dbExecute(dbConnection, createBillsTableStatement)

# create parties table
createPartiesTableStatement <- "
CREATE TABLE IF NOT EXISTS parties (
  genders TEXT PRIMARY KEY,
  party_size INTEGER NOT NULL
);"
dbExecute(dbConnection, createPartiesTableStatement)

# create visits table
createVisitsTableStatement <- "
CREATE TABLE IF NOT EXISTS visits (
  visit_id INTEGER PRIMARY KEY,
  restaurant TEXT NOT NULL,
  visit_date DATE NOT NULL,
  visit_time TIME NOT NULL,
  meal_type TEXT NOT NULL,
  genders TEXT NOT NULL,
  wait_time INTEGER NOT NULL,
  server_emp_id INTEGER,
  customer_phone_number TEXT,
  bill_id INTEGER NOT NULL,
  ordered_alcohol INTEGER CHECK (ordered_alcohol IN (0, 1)),
    
  FOREIGN KEY (genders) REFERENCES parties(genders),
  FOREIGN KEY (server_emp_id) REFERENCES servers(server_emp_id),
  FOREIGN KEY (customer_phone_number) REFERENCES customers(phone_number),
  FOREIGN KEY (bill_id) REFERENCES bills(bill_id)
);
"
dbExecute(dbConnection, createVisitsTableStatement)

# disconnect from database
dbDisconnect(dbConnection)