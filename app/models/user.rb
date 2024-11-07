class User < ApplicationRecord
  has_one :provider
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  enum role: { user: 0, provider: 1, admin: 2 }
  
  after_initialize do
    self.role ||= :user if self.new_record?
  end
end
