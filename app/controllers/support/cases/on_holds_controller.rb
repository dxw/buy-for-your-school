module Support
  class Cases::OnHoldsController < Cases::ApplicationController
    def create
      if current_case.may_hold?
        current_case.interactions.state_change.build(
          body: "From #{current_state} to on hold by #{current_agent.full_name} on #{now}",
          agent_id: current_agent.id,
        )
        current_case.hold!

        redirect_to support_case_path(current_case, anchor: "case-history"),
                    notice: I18n.t("support.case_on_hold.flash.created")

      else
        redirect_to support_case_path(current_case),
                    notice: I18n.t("support.case_on_hold.flash.error")
      end
    end
  end
end
