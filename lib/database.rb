require "sqlite3"
require "csv"

class SalesDB

  attr_reader :db

  def initialize
  	open_db
    create_all_tables
  end

  def open_db
    filename = File.expand_path "sales_info.db", __dir__
    File.delete filename if File.exist? filename
    @db = SQLite3::Database.new filename
    @db.results_as_hash = true
  end

  def create_all_tables
    # create_fruits_table
    # create_sales_table
    # create_customers_table
    # create_orders_view
    create_customers_table
    load_customers
    # create_invoices_table
    # create_invoice_items_table
    # create_items_table
    # create_merchants_table
    # create_transactions_table
  end

  def create_customers_table
    db.execute <<-SQL
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name VARCHAR(30),
        last_name VARCHAR(30),
        created_at DATETIME,
        updated_at DATETIME
      );
    SQL
  end

  def load_customers
    contents = CSV.read('./data/customers.csv')
    contents.shift
    contents.each do |id,first_name,last_name,created_at,updated_at|
      db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);", [first_name, last_name, created_at, updated_at]
    end
  end


  # def create_fruits_table
  #   db.execute <<-SQL  # => []
  #     CREATE TABLE fruits(
  #       id       INTEGER PRIMARY KEY AUTOINCREMENT,
  #       name     VARCHAR(31),
  #       quantity INT
  #     );
  #   SQL
  # end
  #
  # def create_sales_table
  #   db.execute <<-SQL  # => []
  #     CREATE TABLE sales(
  #       id INTEGER PRIMARY KEY AUTOINCREMENT,
  #       fruit_id INTEGER,
  #       customer_id INTEGER,
  #       created_at DATETIME
  #     );
  #   SQL
  # end
  #
  # def create_customers_table
  #   db.execute <<-SQL  # => []
  #     CREATE TABLE customers(
  #       id INTEGER PRIMARY KEY AUTOINCREMENT,
  #       name VARCHAR(63)
  #     );
  #   SQL
  # end
  #
  # def create_orders_view
  #   db.execute <<-SQL
  #     CREATE VIEW orders AS
  #       SELECT customers.name, fruits.name, sales.created_at
  #       FROM fruits
  #       INNER JOIN sales     ON fruits.id         = sales.fruit_id
  #       INNER JOIN customers ON sales.customer_id = customers.id;
  #   SQL
  # end

end

sales_db = SalesDB.new

# sales_db.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);", [first_name, last_name, created_at, updated_at]
sales_db.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES ('Regis', 'BSomething', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
sales_db.db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES ('Adam', 'Jensen', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
customers = sales_db.db.execute 'SELECT * FROM customers;'


# sales_db.db.execute "INSERT INTO fruits(name, quantity) VALUES (?, ?);", ['apples', 6]    # => []
# sales_db.db.execute "INSERT INTO fruits(name, quantity) VALUES (?, ?);", ['oranges', 12]  # => []
# sales_db.db.execute "INSERT INTO fruits(name, quantity) VALUES (?, ?);", ['bananas', 18]  # => []
#
# sales_db.db.execute "INSERT INTO customers(name) VALUES (?);", ['Jeff']     # => []
# sales_db.db.execute "INSERT INTO customers(name) VALUES (?);", ['Violet']   # => []
# sales_db.db.execute "INSERT INTO customers(name) VALUES (?);", ['Vincent']  # => []
#
# sales_db.db.execute 'INSERT INTO sales(fruit_id, customer_id, created_at) VALUES(1, 2, CURRENT_TIMESTAMP);'
# sales_db.db.execute 'INSERT INTO sales(fruit_id, customer_id, created_at) VALUES(3, 2, CURRENT_TIMESTAMP);'
# sales_db.db.execute 'INSERT INTO sales(fruit_id, customer_id, created_at) VALUES(1, 3, CURRENT_TIMESTAMP);'
#
# join_results = sales_db.db.execute '
#   SELECT customers.name, fruits.name, sales.created_at
#   FROM fruits
#   INNER JOIN sales     ON fruits.id         = sales.fruit_id
#   INNER JOIN customers ON sales.customer_id = customers.id;
# '
# view_results = sales_db.db.execute 'SELECT * FROM orders;'
require 'pry';binding.pry
