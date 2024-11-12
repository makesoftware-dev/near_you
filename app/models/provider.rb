class Provider < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true, presence: true
  # validates :calendly_url, format: {with: URL::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must me a valid URL"}, allow_blank: true
  
  enum service_type: {
    electrician: 'Electrician',
    plumber: 'Plumber',
    gardener: 'Gardener',
    masseur: 'Masseur'
  }
end
