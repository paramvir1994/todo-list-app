# frozen_string_literal: true

require 'sqlite3'

# This class is to manage all the database functions.
class Db
  attr_accessor :db
  def initialize(db_name)
    @db = SQLite3::Database.open "#{db_name}"
    @db.results_as_hash = true
  end

  def create_table_if_not_exists(table_name, params)
    # params expect dictionary, for eg:
    # { 'name' => 'TEXT', 'description' => 'TEXT', 'isactive' => 'INT' }
    query_parameters = ''
    params.each do |col_name, col_type|
      query_parameters += " #{col_name} #{col_type},"
    end
    @db.execute "CREATE TABLE IF NOT EXISTS #{table_name}(id INTEGER PRIMARY KEY AUTOINCREMENT,#{query_parameters.delete_suffix(',')})"
  end

  def insert_row(table_name, params_coloumn_name, params_coloumn_values)
    @db.execute "INSERT INTO #{table_name} (#{params_coloumn_name})
                  VALUES (#{params_coloumn_values})"
  end

  def drop_table(table_name)
    @db.execute "DROP TABLE #{table_name}"
  end

  def select_all_from_table(table_name)
    results = @db.query "SELECT * FROM #{table_name}"
    return results
  end

  def select_row_by_id(table_name, id)
    results = @db.query "SELECT * FROM #{table_name} WHERE id = #{id}"
    return results
  end

  def update_row_by_id(table_name, id, set_command)
    @db.query "UPDATE #{table_name} SET #{set_command} WHERE id = #{id}"
  end

  def delete_row_by_id(table_name, id)
    @db.query "DELETE FROM #{table_name} WHERE id = #{id}"
  end

  def close
    @db&.close
  end
end

def test_db
  params = { 'name' => 'TEXT', 'description' => 'TEXT', 'isactive' => 'INT' }
  db = Db.new('test.db')
  db.create_table_if_not_exists('test', params)
  db.insert_row('test', 'name, description, isactive', '\'Build app\', \'create database\', 1')
  db.select_all_from_table('test')
end

# test_db
