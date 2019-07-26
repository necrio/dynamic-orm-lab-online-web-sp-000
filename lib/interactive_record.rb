require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  
  def self.table_name
    self.to_s.downcase.pluralize
  end
  
  def self.colum_names
    DB[:conn].results_as_hash = true 
    
    sql = "pragma table_info ('#{table_name}')"
    
    table_info = DB[:conn].execite(sql)
    colum_names = []
    table_info.each do |row|
      colum_names << row["name"]
    end
    colum_names.compact
  end
  
  def initialize(options={})
    options.each do |prop, valu|
      self.send("#{prop}=", valu)
    end
  end
  
  def save
    sql = "INSERT INTO
   #{table_name_for_insert} (#{col_names_for_insert}) VALUES (#{values_for_insert})"
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
  end
  
   def table_name_for_insert
    self.class.table_name
    puts "nothing to add here."
  end

  def values_for_insert
    values = []
    self.class.column_names.each do |col_name|
      values << "'#{send(col_name)}'" unless send(col_name).nil?
    end
    values.join(", ")
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ")
  end

def self.find_by_name(name)
  sql = "SELECT * FROM #{self.table_name} WHERE name = '?'"
  DB[:conn].execute(sql, name)
end
  
end