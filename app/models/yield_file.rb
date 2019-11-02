class YieldFile < ActiveRecord::Base
  attr_accessible :post_id, :file_name, :total_row, :published_at

  belongs_to :post
  has_many :reports, dependent: :destroy
  has_many :report_mains, dependent: :destroy
  has_many :report_minis, dependent: :destroy
  has_many :stations

  validates :file_name, presence: true, uniqueness: true
  validates :post_id, :total_row, :published_at, presence: true
  validates :total_row, numericality: { only_integer: true }

  before_create do
  	file_extension = File.extname(self.file_name)
    if !file_extension.downcase == '.csv'
      false
    end
  end

  after_create do
    # If failed to import reports, delete the yield file from database 
    unless Report.where('yield_file_id = ?', self.id).first.equal? nil
      self.destroy
    end
  end
end
