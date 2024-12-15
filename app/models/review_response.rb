class ReviewResponse < ApplicationRecord
  belongs_to :review
  belongs_to :provider

  validates :content, presence: true, length: {minimum: 10, maximum: 500}
end
