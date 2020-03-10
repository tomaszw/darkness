class RulesController < ApplicationController
  permit 'index'
  
  def index
    render "/rules"
  end
end
