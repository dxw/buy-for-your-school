# frozen_string_literal: true

require "csv"
require "pg_search"

module Support
  #
  # A case is opened from a "support enquiry" dealing with a "category of spend"
  #
  class Case < ApplicationRecord
    include Filterable
    include StateChangeable
    include Sortable
    include Searchable
    include ActivityLoggable
    include Historyable
    include QuickEditable
    include Summarisable

    belongs_to :category, class_name: "Support::Category", optional: true
    belongs_to :query, class_name: "Support::Query", optional: true
    belongs_to :agent, class_name: "Support::Agent", optional: true
    belongs_to :organisation, polymorphic: true, optional: true
    has_many :emails, class_name: "Support::Email"
    has_many :email_attachments, class_name: "Support::EmailAttachment", through: :emails, source: :attachments
    has_many :exit_survey_responses, class_name: "ExitSurveyResponse"

    has_many :documents, class_name: "Support::Document", dependent: :destroy
    accepts_nested_attributes_for :documents, allow_destroy: true, reject_if: :all_blank

    has_many :case_attachments, class_name: "Support::CaseAttachment", foreign_key: :support_case_id

    has_one :hub_transition, class_name: "Support::HubTransition", dependent: :destroy

    belongs_to :created_by, class_name: "Support::Agent", optional: true

    belongs_to :existing_contract, class_name: "Support::ExistingContract", optional: true
    belongs_to :new_contract, class_name: "Support::NewContract", optional: true
    belongs_to :procurement, class_name: "Support::Procurement", optional: true

    has_many :message_threads, class_name: "Support::MessageThread"

    has_many :energy_bills, class_name: "EnergyBill", foreign_key: :support_case_id

    belongs_to :detected_category, class_name: "Support::Category", optional: true

    belongs_to :procurement_stage, class_name: "Support::ProcurementStage", optional: true

    accepts_nested_attributes_for :hub_transition, allow_destroy: true, reject_if: :all_blank

    # Support level
    #
    #   L1       - Advice and guidance only
    #   L2       - Pointing to a framework / catalogue
    #   L3       - Helping school run a framework but school doing system work
    #   L4       - Run framework on behalf of school
    #   L5       - Run bespoke procurement
    enum support_level: { L1: 0, L2: 1, L3: 2, L4: 3, L5: 4 }

    # Closure reason
    #
    #   resolved
    #   email_merge
    #   spam
    #   out_of_scope
    #   other
    enum closure_reason: { resolved: 0, email_merge: 1, spam: 2, out_of_scope: 3, other: 4 }, _suffix: true

    # Source
    #
    #   digital         - specify cases
    #   nw_hub          - north west hub cases
    #   sw_hub          - south west hub cases
    #   incoming_email  -
    #   faf             - find a framework
    enum source: { digital: 0, nw_hub: 1, sw_hub: 2, incoming_email: 3, faf: 4, engagement_and_outreach: 5, schools_commercial_team: 6, engagement_and_outreach_cms: 7 }

    # Creation Source
    #
    #   default                 - created by a member of the ProcOps team
    #   engagement_and_outreach - created by a member of the E&O team
    enum creation_source: { default: 0, engagement_and_outreach_team: 5 }

    # Savings status
    #
    #   realised   - Realised
    #   potential  - Potential
    #   unrealised - Not realised
    enum savings_status: { realised: 0, potential: 1, unrealised: 2 }

    # Savings estimate method
    #
    #   previous_minus_cheapest  - [Previous spend] - [Cheapest quote]
    #   rrp_minus_cheapest       - [RRP] - [Cheapest quote]
    #   previous_minus_estimated - [Previous spend] - [Estimated Contract Value]
    #   rrp_minus_estimated      - [RRP] - [Estimated Contract Value]
    enum savings_estimate_method: { previous_minus_cheapest: 0, rrp_minus_cheapest: 1, previous_minus_estimated: 2, rrp_minus_estimated: 3 }

    # Savings actual method
    #
    #   previous_minus_award    - [Previous spend] - [Award Price ]
    #   alternative_minus_award - [Alternative received price] - [Award Price ]
    #   rrp_minus_award         - [RRP] - [Award Price ]
    enum savings_actual_method: { previous_minus_award: 0, alternative_minus_award: 1, rrp_minus_award: 2 }

    before_validation :generate_ref
    validates :ref, uniqueness: true, length: { is: 6 }, format: { with: /\A\d+\z/, message: "numbers only" }

    # @return [String]
    def self.to_csv
      CSV.generate(headers: true) do |csv|
        csv << column_names

        find_each { |record| csv << record.attributes.values }
      end
    end

    # Called before validation to assign 6 digit incremental number (from last case or the default 000000)
    # @return [String]
    def generate_ref
      return if ref.present?

      self.ref = (Support::Case.last&.ref || sprintf("%06d", 0)).next
    end

    # @return [Array, Support::Interaction]
    def support_request
      interactions&.support_request&.first
    end
  end
end
