class ProvidersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if current_user.provider?
      @provider = current_user.provider
      if @provider
        redirect_to provider_path(@provider)
      else
        redirect_to new_provider_path, "Please complete you provider profile"
      end
    else
      @service_type = Provider.distinct.pluck(:service_type)
      @providers = Provider.includes(:user)
      if params[:service_type].present?
        @providers = @providers.where(service_type: params[:service_type])
      end
    end
  end
  
  def show
    @provider = Provider.find(params[:id])
  end
end