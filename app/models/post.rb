class Post < ActiveRecord::Base
  
  belongs_to :user
  
  acts_as_taggable

  validates :title, presence: true
  validates :url, presence: true, url: true, uniqueness: true
  validates :user, presence: true
end
