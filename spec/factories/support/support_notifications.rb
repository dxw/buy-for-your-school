FactoryBot.define do
  factory :support_notification, class: "Support::Notification" do
    association :assigned_by, factory: :support_agent
    association :assigned_to, factory: :support_agent

    trait :case_assigned do
      topic { :case_assigned }
      association :support_case
    end

    trait :unread do
      read { false }
    end

    trait :read do
      read { true }
    end
  end
end
