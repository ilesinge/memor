class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable
  # :lockable, :timeoutable and :omniauthable, :recoverable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable
  
  has_many :posts
  
  validates :username, presence: true, uniqueness: true, length: { in: 6..20 }
end
