class Eq < ActiveRecord::Base
  def sales_value
    v = ""
    p = points.to_i
    p = p*1000
    if p < 1000000
      v = (p/1000).to_s + "k"
    else
      v = (p/1000000.0).to_s + "m"
    end
    v
  end
end
