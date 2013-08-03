class Post < ActiveRecord::Base
  
  validates_presence_of :url, :title
  validates_url :url
end
