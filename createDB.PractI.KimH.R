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
filename <- "visits.db"
dbConnection <- dbConnect(RSQLite::SQLite(), filename)

# Create restaurants table
createRestaurantsTableStatement <- "
CREATE TABLE IF NOT EXISTS restaurants (
  restaurant_id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);"
dbExecute(dbConnection, createRestaurantsTableStatement)

# Create meal types table
createMealTypesTableStatement <- "
CREATE TABLE IF NOT EXISTS meal_types (
  meal_types_id INTEGER PRIMARY KEY,
  type TEXT NOT NULL
);"
dbExecute(dbConnection, createMealTypesTableStatement)

# Create servers table
createServersTableStatement <- "
CREATE TABLE IF NOT EXISTS servers (
  server_emp_id INTEGER PRIMARY KEY,
  server_name TEXT NOT NULL,
  server_dob DATE,
  server_tin TEXT
);"
dbExecute(dbConnection, createServersTableStatement)

# Create employment table
createEmploymentTableStatement <- "
CREATE TABLE IF NOT EXISTS employment (
  employment_id INTEGER PRIMARY KEY,
  restaurant_id INTEGER NOT NULL,
  server_emp_id INTEGER NOT NULL,
  hired_start_date DATE NOT NULL,
  hired_end_date DATE,
  hourly_rate NUMERIC,
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
  FOREIGN KEY (server_emp_id) REFERENCES servers(server_emp_id)
);
"
dbExecute(dbConnection, createEmploymentTableStatement)

# Create customers table
createCustomersTableStatement <- "
CREATE TABLE IF NOT EXISTS customers (
  phone_number TEXT PRIMARY KEY,
  name TEXT,
  email TEXT,
  is_loyalty_member INTEGER CHECK (is_loyalty_member IN (0, 1))
);
"
dbExecute(dbConnection, createCustomersTableStatement)

# Create parties table
createPartiesTableStatement <- "
CREATE TABLE IF NOT EXISTS parties (
  genders TEXT PRIMARY KEY,
  party_size INTEGER
);
"
dbExecute(dbConnection, createPartiesTableStatement)

# Create bills table
createBillsTableStatement <- "
CREATE TABLE IF NOT EXISTS bills (
  bill_id INTEGER PRIMARY KEY,
  food_bill NUMERIC,
  alcohol_bill NUMERIC,
  tip_amount NUMERIC,
  discount_applied NUMERIC,
  payment_method TEXT
);
"
dbExecute(dbConnection, createBillsTableStatement)

# Create visits table
createVisitsTableStatement <- "
CREATE TABLE IF NOT EXISTS visits (
  visit_id INTEGER PRIMARY KEY,
  restaurant_id INTEGER NOT NULL,
  visit_date DATE,
  visit_time TIME,
  meal_type INTEGER,
  genders TEXT,
  wait_time INTEGER,
  server_emp_id INTEGER,
  customer_phone_number TEXT,
  bill_id INTEGER NOT NULL,
  ordered_alcohol INTEGER CHECK (ordered_alcohol IN (0, 1)),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
  FOREIGN KEY (meal_type) REFERENCES meal_types(meal_types_id),
  FOREIGN KEY (genders) REFERENCES parties(genders),
  FOREIGN KEY (server_emp_id) REFERENCES servers(server_emp_id),
  FOREIGN KEY (customer_phone_number) REFERENCES customers(phone_number),
  FOREIGN KEY (bill_id) REFERENCES bills(bill_id)
);
"
dbExecute(dbConnection, createVisitsTableStatement)

# disconnect from database
dbDisconnect(dbConnection)