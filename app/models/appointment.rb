class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :provider

  enum status: {pending: 0, confirmed: 1, completed: 2, cancelled: 3}
end
