# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent
  include Pundit::Authorization
  include InsightsTrackable
  include ExceptionDataPrepareable

  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  before_action :authenticate_user!, except: %i[health_check maintenance]

  protect_from_forgery

  add_flash_types :success

  def health_check
    render json: { rails: "OK" }, status: :ok
  end

  def maintenance
    redirect_to root_path unless Flipper.enabled?(:maintenance_mode)
  end

protected

  helper_method :current_user, :cookie_policy, :record_ga?, :engagement_portal?, :support_portal?, :frameworks_portal?

  # @return [User, Guest]
  #
  def current_user
    @current_user ||= CurrentUser.new.call(uid: session[:dfe_sign_in_uid])
  end

  # before_action - Ensure session is ended
  #
  # @return [nil]
  #
  def authenticate_user!
    return unless current_user.guest?

    session.delete(:dfe_sign_in_uid)
    redirect_to root_path, notice: I18n.t("banner.session.visitor")
  end

  # @return [Journey]
  #
  def current_journey
    journey_id = params[:journey_id].presence || params[:id]
    @current_journey ||= JourneyPresenter.new(Journey.find(journey_id))
  end

  # `Before Action` on:
  #   - steps_controller
  #   - answers_contorller
  #   - journeys_controller
  #   - specifications_controller
  #
  def check_user_belongs_to_journey?
    return true if current_journey.user == current_user

    render "errors/not_found", status: :not_found
  end

  def support_portal?
    portal_namespace.to_s.inquiry.support?
  end

  def engagement_portal?
    portal_namespace.to_s.inquiry.engagement?
  end

  def frameworks_portal?
    portal_namespace.to_s.inquiry.frameworks?
  end

  def portal_namespace
    :none
  end

  def record_ga?
    !(support_portal? || engagement_portal? || frameworks_portal?)
  end

  def cookie_policy
    CookiePolicy.new(cookies)
  end

  def current_url_b64
    Base64.encode64(request.fullpath)
  end

  def tracking_base_properties = { user_id: current_user.id }
end
