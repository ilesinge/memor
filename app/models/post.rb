class Post < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :url, :title
  validates_url :url
end
