module FrameworkRequests
  class SelectOrganisationsController < BaseController
  private

    def form
      @form ||= FrameworkRequests::SelectOrganisationForm.new(all_form_params)
    end

    def form_params
      %i[org_id group]
    end

    def create_redirect_path
      message_framework_requests_path(framework_support_form: form.common)
    end

    def back_url
      @back_url = framework_requests_path
    end
  end
end