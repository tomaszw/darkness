class CreatePartyMembers < ActiveRecord::Migration
  def self.up
    create_table :party_members do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :party_members
  end
end
