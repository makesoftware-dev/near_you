class ReviewResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review_and_response, only: [:update, :destroy]
  before_action :ensure_response_owner, only: [:update, :destroy]

  def create
    @review = Review.find(params[:review_id])
    @response = @review.review_responses.build(response_params)

    @response.provider = current_user.provider

    if @response.save
      redirect_to provider_path(@review.provider), notice: "Response submitted successfully!"
    else
      redirect_to provider_path(@review.provider), alert: @response.errors.full_messages.join(", ")
    end
  end

  def update
    if @response.update(response_params)
      respond_to do |format|
        format.html { redirect_to provider_path(@review.provider), notice: "Response updated successfully!" }
        format.js   # This will look for update.js.erb
      end
    else
      respond_to do |format|
        format.html { redirect_to provider_path(@review.provider), alert: @response.errors.full_messages.join(", ") }
        format.js   # Handle errors in JavaScript
      end
    end
  end

  def destroy
    @response.destroy
    redirect_to provider_path(@review.provider), notice: "Response deleted successfully!"
  end

  private

  def set_review_and_response
    @review = Review.find(params[:review_id])
    @response = @review.review_responses.find(params[:id])
  end

  def ensure_response_owner
    unless current_user.provider?
      redirect_to provider_path(@review.provider), alert: "You can only edit or delete your own responses."
    end
  end

  def response_params
    params.require(:review_response).permit(:content)
  end
end
