require_relative 'customer_repository'
require_relative 'invoice_repository'
require_relative 'transaction_repository'
require_relative 'invoice_item_repository'
require_relative 'merchant_repository'
require_relative 'item_repository'
require_relative 'repository'
require 'pry'
require 'csv'
require 'sqlite3'


class SalesEngine
  attr_reader :customer_repository, :invoice_repository,
              :transaction_repository, :invoice_item_repository,
               :merchant_repository, :item_repository, :csv_path, :db

  def initialize(csv_path = our_folder)
    @csv_path = csv_path
  end

  def our_folder
    our_root = File.expand_path('../..',  __FILE__)
    File.join our_root, "data"
  end

  def startup
    open_db
    # build_all_tables
    create_repositories
  end

  def create_repositories
    @customer_repository = CustomerRepository.new(self)
    @invoice_repository = InvoiceRepository.new(self)
    @transaction_repository = TransactionRepository.new(self)
    @invoice_item_repository = InvoiceItemRepository.new(self)
    @merchant_repository = MerchantRepository.new(self)
    @item_repository = ItemRepository.new(self)
  end

  def open_db
    filename = File.expand_path "sales_info.db", __dir__
    # File.delete filename if File.exist? filename
    @db = SQLite3::Database.new filename
    # @db.results_as_hash = true
  end

  def build_all_tables
    create_customers_table
    load_customers
    create_invoices_table
    load_invoices
    create_invoice_items_table
    load_invoice_items
    create_items_table
    load_items
    create_merchants_table
    load_merchants
    create_transactions_table
    load_transactions
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
    CSV.foreach(File.join(csv_path, 'customers.csv'), headers: true, :header_converters => :symbol) do |row|
      db.execute "INSERT INTO customers(first_name, last_name, created_at, updated_at) VALUES (?,?,?,?);", [row[:first_name], row[:last_name], row[:created_at][0..18], row[:updated_at][0..18]]
    end
  end

  def create_invoices_table
    db.execute <<-SQL
      CREATE TABLE invoices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER,
        merchant_id INTEGER,
        status VARCHAR(20),
        created_at DATETIME,
        updated_at DATETIME
      );
    SQL
  end

  def load_invoices
    CSV.foreach(File.join(csv_path, 'invoices.csv'), headers: true, :header_converters => :symbol) do |row|
      db.execute "INSERT INTO invoices(customer_id,merchant_id,status,created_at,updated_at) VALUES (?,?,?,?,?);", [row[:customer_id],row[:merchant_id],row[:status],row[:created_at][0..18],row[:updated_at][0..18]]
    end
  end

  def create_invoice_items_table
      db.execute <<-SQL
        CREATE TABLE invoice_items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          item_id INTEGER,
          invoice_id INTEGER,
          quantity INTEGER,
          unit_price INTEGER,
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL
    end

    def load_invoice_items
      CSV.foreach(File.join(csv_path, 'invoice_items.csv'), headers: true, :header_converters => :symbol) do |row|
        db.execute "INSERT INTO invoice_items(item_id,invoice_id,quantity,unit_price,created_at,updated_at) VALUES (?,?,?,?,?,?);", [row[:item_id],row[:invoice_id],row[:quantity],row[:unit_price],row[:created_at][0..18],row[:updated_at][0..18]]
      end
    end

    def create_items_table
      db.execute <<-SQL
        CREATE TABLE items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(50),
          description VARCHAR(300),
          unit_price INTEGER,
          merchant_id INTEGER,
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL
    end

    def load_items
      CSV.foreach(File.join(csv_path, 'items.csv'), headers: true, :header_converters => :symbol) do |row|
        db.execute "INSERT INTO items(name,description,unit_price,merchant_id,created_at,updated_at) VALUES (?,?,?,?,?,?);", [row[:name],row[:description],row[:unit_price],row[:merchant_id],row[:created_at][0..18],row[:updated_at][0..18]]
      end
    end

    def create_merchants_table
      db.execute <<-SQL
        CREATE TABLE merchants(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(50),
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL
    end

    def load_merchants
      CSV.foreach(File.join(csv_path, 'merchants.csv'), headers: true, :header_converters => :symbol) do |row|
        db.execute "INSERT INTO merchants(name,created_at,updated_at) VALUES (?,?,?);", [row[:name],row[:created_at][0..18],row[:updated_at][0..18]]
      end
    end

    def create_transactions_table
      db.execute <<-SQL
        CREATE TABLE transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          invoice_id INTEGER,
          credit_card_number VARCHAR(16),
          credit_card_expiration_date VARCHAR(16),
          result VARCHAR(10),
          created_at DATETIME,
          updated_at DATETIME
        );
      SQL
    end

    def load_transactions
      CSV.foreach(File.join(csv_path, 'transactions.csv'), headers: true, :header_converters => :symbol) do |row|
        db.execute "INSERT INTO transactions(invoice_id,credit_card_number,credit_card_expiration_date,result,created_at,updated_at) VALUES (?,?,?,?,?,?);", [row[:invoice_id],row[:credit_card_number],row[:credit_card_expiration_date],row[:result],row[:created_at][0..18],row[:updated_at][0..18]]
      end
    end
end

engine = SalesEngine.new()
engine.startup
if __FILE__ == $0
  puts "Using csv folder.... #{engine.csv_path}"
  binding.pry
end
