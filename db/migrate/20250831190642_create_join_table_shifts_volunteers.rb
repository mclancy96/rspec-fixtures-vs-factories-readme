class CreateJoinTableShiftsVolunteers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :shifts, :volunteers do |t|
      # t.index [:shift_id, :volunteer_id]
      # t.index [:volunteer_id, :shift_id]
    end
  end
end
