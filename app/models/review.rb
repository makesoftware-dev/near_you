class Review < ApplicationRecord
  belongs_to :user
  belongs_to :provider
  belongs_to :appointment
  has_many :review_responses, dependent: :destroy

  validates :rating, presence: true, inclusion: {in: 1..5}
  validates :content, presence: true, length: {minimum: 10, maximum: 500}

  after_destroy :recalculate_provider_rating

  private

  def recalculate_provider_rating
    provider.recalculate_average_rating!
  end
end
