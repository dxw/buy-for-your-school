RSpec.describe Support::CaseDatum, type: :model do
  describe "#to_csv" do
    it "includes headers" do
      expect(described_class.to_csv).to eql(
        "case_id,case_ref,created_at,created_date,created_year,created_month,created_financial_year,last_modified_at,last_modified_date,last_modified_year,last_modified_month,first_resolved_date,last_resolved_date,case_source,case_creation_source,case_state,case_closure_reason,sub_category_title,category_other,tower_name,agent_name,savings_actual,savings_actual_method,savings_estimate,savings_estimate_method,savings_status,case_support_level,case_value,with_school_flag,next_key_date,next_key_date_description,organisation_contact_email,organisation_name,organisation_urn,organisation_ukprn,organisation_rsc_region,parent_group_name,parent_group_ukprn,organisation_local_authority_name,organisation_local_authority_code,gor_name,organisation_uid,organisation_phase,organisation_status,establishment_group_status,establishment_type,framework_request_num_schools,framework_request_school_urns,case_request_num_schools,case_request_school_urns,case_num_participating_schools,case_participating_school_urns,framework_name,reason_for_route_to_market,required_agreement_type,route_to_market,procurement_stage_old,procurement_stage,procurement_stage_key,procurement_started_at,procurement_ended_at,e_portal_reference,previous_contract_started_at,previous_contract_ended_at,previous_contract_duration,previous_contract_spend,previous_contract_supplier,new_contract_started_at,new_contract_ended_at,new_contract_duration,new_contract_spend,new_contract_supplier,supplier_is_a_sme,participation_survey_date,exit_survey_date,referrer\n",
      )
    end
  end
end
