module Support
  class CaseContractsFormSchema < Schema
    config.messages.top_namespace = :case_contracts_form

    params do
      optional(:supplier).maybe(:string)
      optional(:started_at).maybe(:hash)
      optional(:ended_at).maybe(:hash)
      optional(:spend).maybe(:decimal)
      optional(:duration).maybe(:integer)
    end

    rule :started_at do
      # optional, only applicable to new contracts
      key.failure(:invalid) unless value.values.all?(&:blank?) || hash_to_date.call(value)
    end

    rule :ended_at do
      # optional, only applicable to existing contracts
      key.failure(:invalid) unless value.values.all?(&:blank?) || hash_to_date.call(value)
    end
  end
end
