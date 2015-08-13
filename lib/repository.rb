require_relative 'file_io'
require_relative 'modules/find_by'
require_relative 'modules/find_all_by'
require 'bigdecimal'

class Repository

  include FindBy
  include FindAllBy

  def all
    records = engine.db.execute "SELECT * FROM #{table_name}"
    instances_of(records)
  end

  def random
    record = all.sample
  end

  def find_by(field, data)
    record = db_records(field, data).first
    child_class.new(record, self) if !record.nil?
  end

  def find_all_by(field, data)
    if field.to_s == 'created_at' || field.to_s == 'updated_at'
      find_all_by_date(field, data)
    else
      instances_of(db_records(field, data))
    end
  end

  def find_all_by_date(field, data)
    date_records = engine.db.execute "SELECT * FROM #{table_name} WHERE DATE(#{field.to_s}) = DATE('#{data}')"
    instances_of(date_records)
  end

private

  def db_records(field, data)
  	engine.db.execute "SELECT * FROM #{table_name} WHERE #{field.to_s} = '#{data}'"
  end

  def instances_of(records)
  	records.map {|record| child_class.new(record, self)}
  end

  def inspect
    self.class
  end
end
