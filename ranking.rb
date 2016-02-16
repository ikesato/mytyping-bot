require 'active_record'

class Ranking < ActiveRecord::Base
  belongs_to :game
end
