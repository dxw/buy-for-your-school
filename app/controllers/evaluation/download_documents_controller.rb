module Evaluation
  class DownloadDocumentsController < ApplicationController
    before_action :set_current_case
    before_action :check_user_is_evaluator
    before_action :set_documents
    before_action :set_downloaded_documents
    before_action :set_download_document, only: %i[update]
    before_action { @back_url = evaluation_task_path(@current_case) }
    SUPPORTED_TYPES = [
      "Support::EmailAttachment",
      "EmailAttachment",
      "Support::CaseAttachment",
      "EnergyBill",
      "Support::EmailTemplateAttachment",
      "Support::CaseUploadDocument",
      "Support::EvaluatorsUploadDocument",
    ].freeze
    def show; end

    def update
      update_support_details
      send_data @download_document.file.download, type: @download_document.file_type, disposition: "attachment", filename: @download_document.file_name
    end

  private

    helper_method def current_evaluator
      return @current_evaluator if defined? @current_evaluator

      @current_evaluator = Support::Evaluator.where("support_case_id = ? AND LOWER(email) = LOWER(?)", params[:id], current_user.email).first
    end
    def set_current_case
      @current_case = Support::Case.find(params[:id])
      @evaluation_due_date = @current_case.evaluation_due_date? ? @current_case.evaluation_due_date.strftime("%d %B %Y") : nil
    end

    def set_downloaded_documents
      @downloaded_documents = Support::EvaluatorsDownloadDocument.where(support_case_id: @current_case.id, email: current_user.email)
    end

    def check_user_is_evaluator
      return if current_evaluator.present? && current_user.email.downcase == current_evaluator.email.downcase

      redirect_to root_path, notice: I18n.t("evaluation.tasks.not_permitted")
    end

    def set_documents
      @documents = @current_case.upload_documents
    end

    def update_support_details
      Support::EvaluatorsDownloadDocument.upsert(
        {
          support_case_upload_document_id: params[:document_id],
          support_case_id: @download_document.support_case_id,
          email: current_user.email,
          has_downloaded_documents: true,
        },
        unique_by: %i[email support_case_id support_case_upload_document_id],
      )
    end

    def set_download_document
      @requested_file_type = CGI.unescape(params[:document_type])
      if SUPPORTED_TYPES.include?(@requested_file_type)
        @download_document = @requested_file_type.safe_constantize.find(params[:document_id])
      else
        head :unsupported_media_type
      end
    end
  end
end
