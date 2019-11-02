class Product < ActiveRecord::Base
  attr_accessible :title, :user_id

  belongs_to :user

  has_many :posts, dependent: :destroy

  validates :title, presence: true, length: { :minimum => 3, :maximum => 255 }

  paginates_per 100
end
