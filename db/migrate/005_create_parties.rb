class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :parties
  end
end
