module Support
  class Cases::EmailEvaluatorsController < Cases::ApplicationController
    before_action :set_current_case
    before_action :set_email_addresses
    before_action :set_documents
    before_action :set_template
    before_action { @back_url = support_case_path(@current_case, anchor: "tasklist") }

    def edit
      @draft = Email::Draft.new(
        default_content: default_template,
        default_subject:,
        template_id: @template_id,
        ticket: current_case.to_model,
        to_recipients: @to_recipients,
      ).save_draft!

      @support_email_id = @draft.id
      @email_evaluators = Email::Draft.find(@support_email_id)
      parse_template
    end

    def update
      @email_evaluators = Email::Draft.find(params[:id])
      @email_evaluators.attributes = form_params
      parse_template
      if @email_evaluators.valid?(:new_message)
        @email_evaluators.save_draft!
        @email_evaluators.deliver_as_new_message

        @current_case.update!(sent_email_to_evaluators: true)

        redirect_to @back_url
      else
        render :edit
      end
    end

  private

    def set_current_case
      @current_case = Support::Case.find(params[:case_id])
    end

    def set_email_addresses
      @evaluators = @current_case.evaluators.all
      @email_addresses = @evaluators.map(&:email)
      @to_recipients = @email_addresses.to_json
    end

    def set_documents
      @documents = @current_case.upload_documents
    end

    def form_params
      params.require(:email_evaluators).permit(:html_content)
    end

    def draft_email_params
      params.require(:email_evaluators).permit(:id)
    end

    def default_subject = "Case #{current_case.ref} - invitation to complete procurement evaluation"

    def default_template = render_to_string(partial: "support/cases/email_evaluators/form_template")

    def set_template
      template = Support::EmailTemplate.find_by(title: "Invitation to complete procurement evaluation")
      @template_id = template.id if template
    end

    def formatted_date(date)
      day = date.day
      suffix = case day
               when 1, 21, 31 then "st"
               when 2, 22 then "nd"
               when 3, 23 then "rd"
               else "th"
               end
      "#{day}#{suffix} #{current_case.evaluation_due_date.strftime('%B %Y')}"
    end

    def parse_template
      variables = {
        "organisation_name" => current_case.organisation_name || current_case.email,
        "sub_category" => current_case.sub_category || "[sub_category]",
        "unique_case_specific_link" => "<a target='_blank' rel='noopener noreferrer' href='#{support_case_path(@current_case, anchor: 'tasklist', host: request.host)}'>unique case-specific link</a>",
        "evaluation_due_date" => formatted_date(current_case.evaluation_due_date),
      }

      @parse_template = Liquid::Template.parse(@email_evaluators.body, error_mode: :strict).render(variables)
      @email_evaluators.html_content = @parse_template
    end
  end
end
