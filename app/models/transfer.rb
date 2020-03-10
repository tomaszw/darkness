class Transfer < ActiveRecord::Base
  belongs_to :member_from, :class_name => "Member", :foreign_key => 'member_from'
  belongs_to :member_to, :class_name => "Member", :foreign_key => 'member_to'
end
