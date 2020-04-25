# frozen_string_literal: true

require 'date'

# Review class is to provide comment to the tasks.
class Review
  attr_accessor :comment
end

# Tasks class
class Tasks
  attr_accessor :task_id, :name, :datenew, :description, :isactive, :review
  def initialize(name, description)
    @name = name
    @datenew = Date.today
    @description = description
    @isactive = 1
    @review = Review.new
  end

  def update_name(name)
    @name = name
  end

  def review_task(comment)
    @review.comment = comment
  end

  def show_review
    puts @review.comment
  end
end

# task = Tasks.new('abc', 'Desc hbjhdb')
# puts task.name
# puts task.datenew.to_s
# puts task.description
# task.review_task('This is my review for this task.')
# task.show_review
# task.review_task('Updating review now!')
# task.show_review
