class RawPage < ActiveRecord::Base
  def self.views
    self.where(category: 'view')
  end

  def self.contests
    self.where(category: 'contest')
  end

  def self.winners
    self.where(category: 'winner')
  end

  def self.others
    self.where(category: 'other')
  end
end
