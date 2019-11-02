class Device < ActiveRecord::Base
  attr_accessible :enabled, :uuid, :user_id, :platform
  belongs_to :user
  validates_uniqueness_of :uuid, scope: :user_id
end
