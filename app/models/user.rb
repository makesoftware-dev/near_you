class User < ApplicationRecord
  has_one :provider, dependent: :destroy
  has_many :appointments, dependent: :destroy
    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  enum role: { user: 0, provider: 1, admin: 2 }
  
  after_initialize do
    self.role ||= :user if self.new_record?
  end
  
  def provider?
    role == 'provider'
  end

  def user?
    role == 'user'
  end
end
