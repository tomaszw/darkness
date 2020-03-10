class CreateEqs < ActiveRecord::Migration
  def self.up
    create_table :eqs do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :eqs
  end
end
