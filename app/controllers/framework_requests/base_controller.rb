module FrameworkRequests
  class BaseController < ApplicationController
    before_action :form, only: %i[index create update edit]
    before_action :back_url, except: %i[edit]
    before_action :framework_request, only: %i[edit]

    def index; end

    def create
      if @form.valid?
        @form.save!
        redirect_to create_redirect_path
      else
        render :index
      end
    end

    def edit
      @back_url = edit_back_url
    end

    def update
      if @form.valid?
        @form.save!
        redirect_to framework_request_path(framework_request), notice: I18n.t("support_request.flash.updated")
      else
        render :edit
      end
    end

  private

    def form
      @form ||= FrameworkRequests::BaseForm.new(all_form_params)
    end

    def all_form_params
      params.fetch(:framework_support_form, {}).permit(*%i[
        dsi
        is_energy_request
        energy_request_about
        have_energy_bill
        energy_alternative
        school_type
        org_confirm
        special_requirements_choice
      ], *form_params).merge(id: framework_request_id, user: current_user)
    end

    def framework_request
      @framework_request ||= FrameworkRequestPresenter.new(FrameworkRequest.find(framework_request_id))
    end

    def framework_request_id
      return params[:id] if params[:id]
      return session[:framework_request_id] if session[:framework_request_id]

      session[:framework_request_id] = FrameworkRequest.create!.id
      session[:framework_request_id]
    end

    def back_url; end

    def edit_back_url
      framework_request_path(form.framework_request)
    end

    def back_link_param
      return if params[:back_to].blank?

      Base64.decode64(params[:back_to])
    end

    def create_redirect_path; end

    def update_redirect_path; end

    def update_data; end

    def form_params; end
  end
end
