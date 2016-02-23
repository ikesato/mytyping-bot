require 'active_record'

class Setting < ActiveRecord::Base
  def self.[] (name)
    self.where(name: name).first&.value
  end

  def self.[]= (name, value)
    s = self.where(name: name).first || self.new(name: name)
    s.value = value
    s.save!
  end
end
