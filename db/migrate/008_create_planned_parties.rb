class CreatePlannedParties < ActiveRecord::Migration
  def self.up
    create_table :planned_parties do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :planned_parties
  end
end
