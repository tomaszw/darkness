class CreateEqMades < ActiveRecord::Migration
  def self.up
    create_table :eq_mades do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :eq_mades
  end
end
