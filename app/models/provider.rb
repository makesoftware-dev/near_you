class Provider < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true, presence: true
  
  enum service_type: {
    electrician: 'Electrician',
    plumber: 'Plumber',
    gardener: 'Gardener',
    masseur: 'Masseur'
  }
end
