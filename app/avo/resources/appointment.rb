class Avo::Resources::Appointment < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user, as: :belongs_to
    field :provider, as: :belongs_to
    field :appointment_time, as: :date_time
    field :status, as: :number
  end
end
