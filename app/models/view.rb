class View < ActiveRecord::Base

  validate :url, uniqueness: true

  def taken_at
    Time.at(seconds_since_midnight).getgm.strftime('%l:%M %P')
  end
end
