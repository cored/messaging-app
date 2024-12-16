class RemoveIsDoctorFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :is_doctor, :boolean
  end
end
