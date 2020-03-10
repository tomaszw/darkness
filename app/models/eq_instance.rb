class EqInstance < ActiveRecord::Base
  set_table_name "eqs_made"
  set_primary_key "id"
  belongs_to :eq
  belongs_to :member
  belongs_to :party
  
  def fmt_location
    case location
    when "C"
      "@chest"
    when "S"
      "@sold"
    when "P"
      "@" + member.Username
    when "H"
      "@hidden"
    end
  end
  
  def names
    names = party.members.find :all, :include => :member, :order => 'username'
    names = names.map { |n| n.Username }
  end
  
  def names_with_lite(mbr)
    names.map { |n|
      n != mbr.Username ? n : "<span style=\"color: #ffff00\">#{n}</span>"
    }    
  end
   
  def mob
    eq.mob
  end
    
  def sdesc
    eq.sdesc
  end
  
  def stats
    eq.stats
  end
  
  def points
    eq.points
  end
end
