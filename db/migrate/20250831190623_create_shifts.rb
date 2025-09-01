class CreateShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :shifts do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
