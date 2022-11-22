require "rails_helper"

describe Messages::LogContact do
  def log_contact! = instance.call(support_case_id: support_case.id, agent_id: support_agent.id, event_type: :phone_call, body: "ring")

  let(:instance) { described_class.new }
  let(:support_case) { create(:support_case) }
  let(:support_agent) { create(:support_agent) }

  context "when the contact is saved successfully" do
    it "persists the contact" do
      allow(instance).to receive(:broadcast)

      expect { log_contact! }.to change(Support::Interaction, :count).from(0).to(1)
      interaction = Support::Interaction.last
      expect(interaction.case_id).to eq(support_case.id)
      expect(interaction.agent_id).to eq(support_agent.id)
      expect(interaction.event_type).to eq("phone_call")
      expect(interaction.body).to eq("ring")
    end

    it "broadcasts the contact_to_school_made event" do
      payload = { support_case_id: support_case.id, contact_type: "logged phone call" }

      with_event_handler(listening_to: :contact_to_school_made) do |handler|
        log_contact!
        expect(handler).to have_received(:contact_to_school_made).with(payload)
      end
    end
  end
end