class Article < ActiveRecord::Base
  belongs_to :folder
  validates :title, presence: true
  validates :source_url, presence: true
end
