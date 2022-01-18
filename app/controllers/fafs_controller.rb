class FafsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :faf, only: %i[show edit update]
  before_action :faf_form, only: %i[create update]
  before_action :faf_presenter, only: %i[show]

  def index; end

  # check answers before submission
  def show
    if @faf.submitted?
      # TODO: redirect to faf_submissions_controller
    end
  end

  def new
    @faf_form = FafForm.new(step: 1)
  end

  def create
    @faf_form.advance! if validation.success?
    render :new
  end

  def edit
    @faf_form = FafForm.new(step: params[:step], **@faf.to_h)
  end

  def update
    if validation.success?
      @faf.update!(**@faf.to_h, **@faf_form.to_h)
      redirect_to faf_path(params[:id])
    else
      render :edit
    end
  end

private

  # @return [FafForm] form object populated with validation messages
  def faf_form
    @faf_form = FafForm.new(
      step: form_params[:step],
      messages: validation.errors(full: true).to_h,
      **validation.to_h,
    )
  end

  def form_params
    params.require(:faf_form).permit(:step, :dsi)
  end

  # @return [FafFormSchema] validated form input
  def validation
    FafFormSchema.new.call(**form_params)
  end

  def faf_presenter
    @faf_presenter = FafPresenter.new(@faf)
  end

  # @return [FrameworkRequest]
  def faf
    @faf = FrameworkRequest.find(params[:id])
  end
end
