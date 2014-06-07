class View < ActiveRecord::Base

  def taken_at
    Time.at(seconds_since_midnight).getgm.strftime('%l:%M %P')
  end
end
