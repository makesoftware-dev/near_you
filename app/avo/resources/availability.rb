class Avo::Resources::Availability < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :provider, as: :belongs_to
    field :day_of_week, as: :text
    field :start_time, as: :date_time
    field :end_time, as: :date_time
    field :available, as: :boolean
  end
end
