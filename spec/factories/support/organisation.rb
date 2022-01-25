FactoryBot.define do
  factory :support_organisation, class: "Support::Organisation" do
    id { SecureRandom.uuid }
    urn { SecureRandom.hex[0..6] }
    sequence(:name) { |n| "School ##{n}" }
    address { {} }
    contact { {} }

    phase  { (0..7).to_a.sample }
    gender { (0..3).to_a.sample }
    status { (1..4).to_a.sample }

    association :establishment_type,
                factory: :support_establishment_type

    trait :with_address do
      address { { "town": "London", "county": "", "street": "St James's Passage", "locality": "Duke's Place", "postcode": "EC3A 5DE" } }
    end

    trait :fixed_urn do
      urn { "12345678" }
    end

    trait :fixed_name do
      name { "Example School" }
    end
  end
end
