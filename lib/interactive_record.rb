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
  
end