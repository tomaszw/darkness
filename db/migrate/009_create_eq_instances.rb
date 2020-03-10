class CreateEqInstances < ActiveRecord::Migration
  def self.up
    create_table :eq_instances do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :eq_instances
  end
end
