class FrameworkRequestsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :framework_request, only: %i[show]

  def index
    session[:product_section] = :ghbs_rfh
    session[:faf_referrer] = referral_link
    session[:journey_session_id] = session_id
    create_user_journey
  end

  def show
    @current_user = UserPresenter.new(current_user)
    @back_url = edit_framework_request_special_requirements_path

    if framework_request.submitted?
      redirect_to framework_request_submission_path(framework_request)
    end
  end

private

  def referral_link
    params[:referred_by] ? Base64.decode64(params[:referred_by]) : request.referer || "direct"
  end

  def session_id
    params[:session_id] || SecureRandom.uuid
  end

  # @return [FrameworkRequestPresenter]
  def framework_request
    @framework_request = FrameworkRequestPresenter.new(FrameworkRequest.find(params[:id]))
  end
end
