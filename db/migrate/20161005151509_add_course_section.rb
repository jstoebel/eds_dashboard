class AddCourseSection < ActiveRecord::Migration
  def up
    add_column :transcript, :course_section, :string, after: :course_code
  end

  def down
    remove_column :transcript, :course_section
  end
end
