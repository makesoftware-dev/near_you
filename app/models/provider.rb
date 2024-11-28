class Provider < ApplicationRecord
  belongs_to :user
  has_many :appointments, dependent: :destroy
  validates :user_id, uniqueness: true, presence: true
  # validates :calendly_url, format: {with: URL::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must me a valid URL"}, allow_blank: true

  enum service_type: {
    # Health & Wellness
    masseur: "Masseur",
    personal_trainer: "Personal Trainer",
    nutritionist: "Nutritionist",

    # Home Services
    electrician: "Electrician",
    plumber: "Plumber",
    gardener: "Gardener",

    # Education
    tutor: "Tutor",
    music_teacher: "Music Teacher",
    language_coach: "Language Coach"
  }

  # Define categories
  def self.categories
    {
      "Health & Wellness" => ["Masseur", "Personal Trainer", "Nutritionist"],
      "Home Services" => ["Electrician", "Plumber", "Gardener"],
      "Education" => ["Tutor", "Music Teacher", "Language Coach"]
    }
  end
end
