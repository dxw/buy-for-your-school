module FrameworkRequests
  class ProcurementConfidencesController < BaseController
    skip_before_action :authenticate_user!

  private

    def form
      @form ||= FrameworkRequests::ProcurementConfidenceForm.new(all_form_params)
    end

    def form_params
      [:confidence_level]
    end

    def create_redirect_path
      special_requirements_framework_requests_path(framework_support_form: form.common)
    end

    def back_url
      @back_url = procurement_amount_framework_requests_path(framework_support_form: form.common)
    end

    def step_description
      I18n.t("request.confidence_level.heading")
    end
  end
end
