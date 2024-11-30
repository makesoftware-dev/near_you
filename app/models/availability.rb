class Availability < ApplicationRecord
  belongs_to :provider

  validates :day_of_week, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :available, inclusion: {in: [true, false]}

  # Add day of week validation
  validates :day_of_week, inclusion: {
    in: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
    message: "%{value} is not a valid day of week"
  }

  before_save :set_available_default

  def available?
    available
  end

  private

  def set_available_default
    self.available = true if available.nil?
  end
end
