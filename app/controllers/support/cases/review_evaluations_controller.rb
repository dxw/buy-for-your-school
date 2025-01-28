module Support
  class Cases::ReviewEvaluationsController < Cases::ApplicationController
    before_action :set_current_case
    before_action :set_evalution_files
    before_action { @back_url = support_case_path(@current_case, anchor: "tasklist") }

    def edit
      @evaluators = ReviewEvaluationsForm.new(**@current_evaluator.to_h)
    end

    def update
      @evaluators = ReviewEvaluationsForm.from_validation(validation)
      @review_evaluation_status = @current_case.evaluators.any?(&:evaluation_approved)

      if validation.success? || @review_evaluation_status
        Support::Evaluator.where(id: review_evaluation_params[:evaluation_approved]).update_all(evaluation_approved: true)
        redirect_to @back_url
      else
        render :edit
      end
    end

  private

    def set_current_case
      @current_case = Support::Case.find(params[:case_id])
    end

    def set_current_evaluator
      @current_evaluator = Support::Evaluator.find(params[:case_id])
    end

    def validation
      @validation ||= ReviewEvaluationsFormSchema.new.call(**review_evaluation_params)
    end

    def set_evalution_files
      @evalution_files = Support::EvaluatorsUploadDocument.where(support_case_id: params[:case_id])
    end

    def review_evaluation_params
      params.require(:review_evaluations_form).permit(evaluation_approved: []).tap do |whitelisted|
        whitelisted[:evaluation_approved].reject!(&:blank?) if whitelisted[:evaluation_approved].is_a?(Array)
      end
    end
  end
end
