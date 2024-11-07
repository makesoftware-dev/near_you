class Avo::Resources::Provider < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :service_type, as: :text
    field :experience, as: :number
    field :hourly_rate, as: :number
    field :bio, as: :textarea
    field :rating, as: :number
    field :location, as: :text
    field :user, as: :belongs_to
  end
end
