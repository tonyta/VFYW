class View < ActiveRecord::Base

  mount_uploader :image, ImageUploader

  validate :url, uniqueness: true

  def taken_at
    Time.at(seconds_since_midnight).getgm.strftime('%l:%M %P')
  end


end
