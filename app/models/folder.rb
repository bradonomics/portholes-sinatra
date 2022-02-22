class Folder < ActiveRecord::Base
  before_save :set_permalink

  has_many :articles
  validates :name, presence: true

  private

    def set_permalink
      self.permalink = name.parameterize
    end

end
