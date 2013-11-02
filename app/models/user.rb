class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :registerable
  # :lockable, :timeoutable and :omniauthable, :recoverable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable
  
  has_many :posts
  
  validates :username, presence: true, uniqueness: true, length: { :in => 6..20 },
    format: { :with => /\A[a-zA-Z]+[a-zA-Z1-9_-]+\Z/i }
      
  def to_param
    username
  end
  
  def email_required?
    false
  end
  
end
