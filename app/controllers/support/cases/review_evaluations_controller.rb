module Support
  class Cases::ReviewEvaluationsController < Cases::ApplicationController
    before_action :set_current_case
    before_action :set_evaluation_files
    before_action :set_template
    before_action { @back_url = support_case_path(@current_case, anchor: "tasklist") }

    def edit; end

    def update
      reset_evaluation_approvals
      approve_selected_evaluations
      update_procurement_stage_if_needed
      send_approval_email

      redirect_to @back_url
    end

  private

    def set_current_case
      @current_case = Support::Case.find(params[:case_id])
    end

    def set_current_evaluator
      @current_evaluator = Support::Evaluator.find(params[:case_id])
    end

    def set_evaluation_files
      @evaluation_files = Support::EvaluatorsUploadDocument.where(support_case_id: params[:case_id])
    end

    def reset_evaluation_approvals
      Support::Evaluator.where(support_case_id: params[:case_id]).update_all(evaluation_approved: false)
    end

    def approve_selected_evaluations
      filtered_params = filter_blank_evaluations(review_evaluations_params)
      Support::Evaluator.where(email: filtered_params[:evaluation_approved]).update_all(evaluation_approved: true)
    end

    def evaluation_pending?
      @current_case.evaluators.where(evaluation_approved: false).any?
    end

    def update_procurement_stage_if_needed
      moderation_stage = if evaluation_pending?
                           Support::ProcurementStage.find_by(stage: "3", title: "Stage 3 Evaluation")
                         else
                           Support::ProcurementStage.find_by(stage: "3", title: "Moderation")
                         end
      @current_case.update!(procurement_stage_id: moderation_stage.id) if moderation_stage
    end

    def review_evaluations_params
      params.require(:review_evaluations_form).permit(evaluation_approved: [])
    end

    def filter_blank_evaluations(params)
      params[:evaluation_approved] = params[:evaluation_approved].reject(&:blank?)
      params
    end

    def default_subject = "Case #{current_case.ref} - email notification of evaluation being approved"

    def default_template = render_to_string(partial: "support/cases/review_evaluations/default_template")

    def set_template
      @template = Support::EmailTemplate.find_by(title: "Email notification of evaluation being approved")
      @template_id = @template.id if @template
    end

    def parse_template
      @email_evaluators.html_content = Support::EmailEvaluatorsVariableParser.new(@current_case, @email_evaluators).parse_template
    end

    def send_approval_email
      filtered_params = filter_blank_evaluations(review_evaluations_params)
      if filtered_params[:evaluation_approved].any?
        filtered_params[:evaluation_approved].each do |evaluator_email|
          draft_and_send_email(evaluator_email.to_json)
        end
      end
    end

    def draft_and_send_email(to_recipients)
      draft = Email::Draft.new(
        default_content: default_template,
        default_subject:,
        template_id: @template_id,
        ticket: current_case.to_model,
        to_recipients:,
      ).save_draft!

      @email_evaluators = Email::Draft.find(draft.id)

      @email_evaluators.attributes = { html_content: @template.body } if @template

      parse_template

      @email_evaluators.save_draft!
      @email_evaluators.deliver_as_new_message
    end
  end
end
