class CreatePartySignups < ActiveRecord::Migration
  def self.up
    create_table :party_signups do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :party_signups
  end
end
