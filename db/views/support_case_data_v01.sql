SELECT
  sc.id AS case_id,
  sc.ref AS case_ref,
  sc.created_at AS created_at,
  GREATEST(sc.updated_at, si.created_at) AS last_modified_at,
  sc.source AS case_source,
  sc.state AS case_state,
  cat.title AS category_title,
  sc.savings_actual AS savings_actual,
	sc.savings_actual_method AS savings_actual_method,
	sc.savings_estimate AS savings_estimate,
	sc.savings_estimate_method AS savings_estimate_method,
	sc.savings_status AS savings_status,
  se.name AS organisation_name,
  se.urn AS organisation_urn,
  se.ukprn AS organisation_ukprn,
  se.rsc_region AS organisation_rsc_region,
  se.local_authority_name AS organisation_local_authority_name,
  se.local_authority_code AS organisation_local_authority_code,
  se.uid AS organisation_uid,
  se.phase AS organisation_phase,
  se.organisation_status AS organisation_status,
  se.egroup_status AS establishment_group_status,
  se.establishment_type AS establishment_type,
  sp.framework_name AS framework_name,
  sp.reason_for_route_to_market AS reason_for_route_to_market,
	sp.required_agreement_type AS required_agreement_type,
	sp.route_to_market AS route_to_market,
	sp.stage AS procurement_stage,
	sp.started_at AS procurement_started_at,
	sp.ended_at AS procurement_ended_at,
  ec.started_at AS previous_contract_started_at,
	ec.ended_at AS previous_contract_ended_at,
	ec.duration as previous_contract_duration,
	ec.spend AS previous_contract_spend,
	ec.supplier AS previous_contract_supplier,
  nc.started_at AS new_contract_started_at,
	nc.ended_at AS new_contract_ended_at,
	nc.duration as new_contract_duration,
	nc.spend AS new_contract_spend,
	nc.supplier AS new_contract_supplier
FROM
  support_cases sc
LEFT JOIN
  support_interactions si
ON si.id =
  (
    SELECT id
    FROM support_interactions i
    WHERE i.case_id = sc.id
    ORDER BY i.created_at ASC
    LIMIT 1
  )
LEFT JOIN (
  SELECT
  organisations.id,
  organisations.name,
  organisations.rsc_region,
  organisations.local_authority->>'name' as local_authority_name,
  organisations.local_authority->>'code' as local_authority_code,
  organisations.urn,
  organisations.ukprn,
  organisations.status as organisation_status,
  null as egroup_status,
  null as uid,
  organisations.phase,
  etypes.name as establishment_type,
  'Support::Organisation' as source
  FROM support_organisations organisations
  JOIN support_establishment_types etypes
    ON etypes.id = organisations.establishment_type_id
  UNION ALL
  SELECT
  egroups.id,
  egroups.name,
  null as rsc_region,
  null as local_authority_name,
  null as local_authority_code,
  null as urn,
  egroups.ukprn,
  null as organisation_status,
  egroups.status as egroup_status,
  egroups.uid,
  null as phase,
  egtypes.name as establishment_type,
  'Support::EstablishmentGroup' as source
  FROM support_establishment_groups egroups
  JOIN support_establishment_group_types egtypes
    ON egtypes.id = egroups.establishment_group_type_id
  ) AS se
ON sc.organisation_id = se.id AND sc.organisation_type = se.source
LEFT JOIN support_categories cat
  ON sc.category_id = cat.id
LEFT JOIN support_procurements sp
  ON sc.procurement_id = sp.id
LEFT JOIN support_contracts ec
  ON sc.existing_contract_id = ec.id
LEFT JOIN support_contracts nc
  ON sc.existing_contract_id = nc.id;
