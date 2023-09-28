module Frameworks::Evaluation::StatusChangeable
  extend ActiveSupport::Concern

  included do
    include AASM

    enum status: {
      draft: 0,
      in_progress: 1,
      approved: 2,
      not_approved: 3,
      cancelled: 4,
    }, _scopes: false

    aasm column: :status do
      Frameworks::Evaluation.statuses.each { |status, _| state status.to_sym }

      event :start do
        transitions from: :draft, to: :in_progress, after: :after_starting_evaluation
      end

      event :approve do
        transitions from: :in_progress, to: :approved, after: :after_approving
      end

      event :disapprove do
        transitions from: :in_progress, to: :not_approved, after: :after_disapproving
      end

      event :cancel do
        transitions from: :in_progress, to: :cancelled, after: :after_cancelling
      end
    end
  end

private

  def after_starting_evaluation
    framework.start_evaluation!(self)
  end

  def after_approving
    framework.approve_evaluation!(self)
  end

  def after_disapproving
    framework.disapprove_evaluation!(self)
  end

  def after_cancelling
    framework.cancel_evaluation!(self)
  end
end
