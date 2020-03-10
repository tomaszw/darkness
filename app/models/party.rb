class Party < ActiveRecord::Base
  has_many :party_members
  has_many :eq_instances
  
  alias :members :party_members

  def date
    partydate
  end
  
  def member_names
    party_members.find(:all, :include => :member, :order => :username).map { |m| m.Username }
  end
  
  def member_names_with_effort
    party_members.find(:all, :include => :member, :order => :username).map { |m| 
      if m.effort == 100
        m.Username
      else
        m.Username + "(#{m.effort}%)"
      end
    }
  end
  
  def points
    connection.select_one("SELECT party_points(#{id}) as pp")["pp"].to_i
  end
  
  def add_member(m)   
    transaction do
      pm = PartyMember.new
      pm.party_id = id
      pm.member_id = m.id
      pm.effort = 100
      pm.save!
      #party_members << pm
      save!
    end 
  end
  
  def add_eq(eq)
    transaction do
      ins = EqInstance.new
      ins.party_id = id
      ins.eq_id = eq.id
      ins.location = 'C'
      ins.save!
      #eq_instances << ins
      save!
    end
  end
end
