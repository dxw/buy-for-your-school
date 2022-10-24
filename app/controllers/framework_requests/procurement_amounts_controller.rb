module FrameworkRequests
  class ProcurementAmountsController < BaseController
    skip_before_action :authenticate_user!

  private

    def form
      @form ||= FrameworkRequests::ProcurementAmountForm.new(all_form_params)
    end

    def form_params
      [:procurement_amount]
    end

    def create_redirect_path
      procurement_confidence_framework_requests_path(framework_support_form: form.common)
    end

    def back_url
      @back_url = message_framework_requests_path(framework_support_form: form.common)
    end

    def step_description
      I18n.t("request.procurement_amount.heading")
    end
  end
end
