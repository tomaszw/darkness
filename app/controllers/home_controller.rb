class HomeController < ApplicationController
  layout 'default'
  
  permit 'index'
  permit 'set_member_email'
  permit 'set_member_reinc'
  
  in_place_edit_for :member, :email
  in_place_edit_for :member, :reinc
  
  def index
    @username = me.Username
    @member = me
    @eq_instances = me.claimed_eq
    @omit_location = true
    @omit_cb = true
    render :action => 'home'
  end
end