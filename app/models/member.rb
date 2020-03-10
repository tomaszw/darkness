class Member < ActiveRecord::Base
  set_primary_key "id"

  def self.authenticate(login, pass)
    find_first(["username = ? AND pass = ?", login, pass])
  end 
  
  def admin
    is_admin?
  end
  
  def admin= (adm)
    @make_admin = adm
  end
  
  def update_role
    if @make_admin == '1'
      connection.execute "update roles set role = 'admin' where username = '#{username}'"
    else
      connection.execute "update roles set role = 'member' where username = '#{username}'"
    end
  end
  
  def is_admin?
    r = Role.find_by_username(username)
    r.name == "admin"
  end
 
  def Username
    return username.capitalize
  end
  
  def claimed_eq
    EqInstance.find :all, :include => :eq, :order => 'eqs.sdesc', :conditions => ["location = 'P' and member_id = ?", id]
  end
  
  def change_password(pass)
    update_attribute "pass", pass
  end
  
  def total_pool_points
    connection.select_value("SELECT total_worth('#{username}')").to_i
  end
  
  def pool_points
    connection.select_value("SELECT current_points('#{username}')").to_i
  end
  
  def dice_points
    connection.select_value("SELECT current_dice_points('#{username}')").to_i
  end
  
  def total_dice_points
    parties = Party.find :all, :include => [:party_members], :conditions => ['party_members.member_id = ?', id]
    sum = 0
    parties.each do |p|
      sum += p.points/1000
    end
    sum
  end
  
  protected
  
  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
  
  # before_create :crypt_password
  
  
  def crypt_password
    # write_attribute("password", self.class.sha1(password))
  end
  
  validates_length_of :username, :within => 2..40
  validates_presence_of :username
  validates_uniqueness_of :username, :on => :create
  validates_confirmation_of :pass, :on => :create     
end
