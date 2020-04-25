# frozen_string_literal: true

require 'date'
require_relative 'tasks'
require_relative 'database'

def display_todo(db, table_name)
  results = db.select_all_from_table(table_name)
  decorate
  puts "Task Id\t\tTask Name\t\tStatus\t\tDescription"
  decorate
  results.each do |row| 
    status = nil
    if Date.today.to_s == row['date'] 
      if row['isactive'] == 1
        status = 'Active'
      else
        status = 'Finished'
      end
      puts "#{row['id']}\t\t#{row['name']}\t\t#{status}\t\t#{row['description']}"
    end
  end
  decorate
end

def newline
  puts "\n\n"
end

def decorate
  puts '-' * 100
end

def help
  decorate
  puts 'Help Menu - You can enter following commands'
  decorate
  puts 'ls: Display Today\'s list!'
  puts 'la: Display all tasks.'
  puts 'i : Insert new task in the list'
  puts 'd : Delete task'
  puts 'da: Delete all tasks!'
  puts 'u : Update task details'
  puts 'f : Finish task'
  puts 'e : Exit'
end

def insert_task(db, table_name)
  puts 'Enter Task name:'
  task_name = gets.chomp
  puts 'Enter task description:'
  task_desc = gets.chomp
  t = Tasks.new(task_name, task_desc)
  db.insert_row(table_name, 'name, description, date, isactive', "\'#{t.name}\', \'#{t.description}\'
    ,\'#{t.datenew}\',1")
  puts '1 Task inserted.'
end

def display(db, table_name)
  newline
  puts 'Enter your choice:'
  input = gets.chomp
  case input
  when 'ls'
    display_todo(db, table_name)
  when 'exit', 'e'
    exit
  when 'help', 'h'
    help
  when 'insert', 'i'
    insert_task(db, table_name)
  when 'delete', 'd'
    delete_task(db, table_name)
  when 'deleteall', 'da'
    delete_all(db, table_name)
  when 'u', 'update'
    update_task(db, table_name)
  when 'finish', 'f'
    finish_task(db, table_name)
  else
    puts 'Invalid Input entered. Enter help or h for Help menu.'
  end
end

def update_task(db, table_name)
  task_name, task_date, task_isactive, task_description = nil
  display_todo(db, table_name)
  newline
  puts 'Enter task number to update:'
  task_number_update = gets.chomp.to_i
  results = db.select_row_by_id(table_name, task_number_update)
  results.each do |row| 
    # puts "#{row['id']}\t\t#{row['name']}\t\t#{row['description']}"
    task_name = row['name']
    task_date = row['date']
    task_isactive = row['isactive']
    task_description = row['description']
  end
  puts 'Enter task new name: (Press Enter Key to not modify)'
  new_name = gets
  if new_name == "\n"
    new_name = task_name
  end
  puts 'Enter task new description: (Press Enter Key to not modify)'
  new_description = gets
  if new_description == "\n"
    new_description = task_description
  end
  puts 'Is task completed? (y/n) (Press Enter Key to not modify)'
  new_status = gets
  if new_status == "\n"
    new_status = task_isactive
  elsif new_status.chomp == "y"
    new_status = 0
  else
    new_status = 1
  end
  db.update_row_by_id(table_name, task_number_update, "name = \'#{new_name}\', 
    description = \'#{new_description}\', isactive = #{new_status}")
  puts '1 task updated.'
end

def finish_task(db, table_name)
  display_todo(db, table_name)
  puts 'Enter task number to mark finished:'
  task_number = gets.chomp
  db.update_row_by_id(table_name, task_number, "isactive = 0")
  puts '1 task updated.'
  display_todo(db, table_name)
end

def delete_task(db, table_name)
  display_todo(db, table_name)
  newline
  puts 'Enter task number to delete:'
  task_number_delete = gets.chomp.to_i
  db.delete_row_by_id(table_name, task_number_delete)
  puts '1 task deleted.'
end

def delete_all(db, table_name)
  db.drop_table(table_name)
  params = { 'name' => 'TEXT', 'description' => 'TEXT', 'date' => 'TEXT', 'isactive' => 'INT' }
  db.create_table_if_not_exists(table_name, params)
end

def on_load
  db = Db.new('todo_app.db')
  table_name = 'tasks'
  params = { 'name' => 'TEXT', 'description' => 'TEXT', 'date' => 'TEXT', 'isactive' => 'INT' }
  db.create_table_if_not_exists(table_name, params)
  return db, table_name
end

def main
  db, table_name = nil
  db, table_name = on_load
  loop_on = true
  puts 'Welcome to your To Do list!'
  display(db, table_name) while loop_on
end

main if __FILE__ == $PROGRAM_NAME
