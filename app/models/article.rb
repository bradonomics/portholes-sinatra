class Article < ActiveRecord::Base
  belongs_to :folder
  validates :title, presence: true
  validates :link, presence: true
end
