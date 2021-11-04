require "dsi/uri"

RSpec.describe Dsi::Uri do
  subject(:service) { described_class.new }

  let(:env) { nil }

  let(:result) { service.call.to_s }

  around do |example|
    ClimateControl.modify(DSI_ENV: env) { example.run }
  end

  describe "#call" do
    it "returns a URI" do
      expect(service.call).to be_a URI
    end

    it "uses HTTPS protocol" do
      expect(service.call.scheme).to eql "https"
    end

    it "uses standard HTTPS port" do
      expect(service.call.port).to be 443
    end

    it "defaults to have no path" do
      expect(service.call.path).to eq ""
    end

    it "defaults to have no query" do
      expect(service.call.query).to be nil
    end

    it "raises URI::InvalidComponentError if path does not begin with '/'" do
      expect { described_class.new(path: "foo").call }.to raise_error(URI::InvalidComponentError)
    end

    it "raises ArgumentError if query is not given as a hash" do
      expect { described_class.new(query: "").call }.to raise_error(ArgumentError)
    end

    describe "env" do
      it "raises an error for invalid environments" do
        expect { described_class.new(env: "foo").call }.to raise_error(Dry::Types::ConstraintError)
      end

      context "when DSI_ENV is 'production'" do
        let(:env) { "production" }

        it "targets the production environment subdomains" do
          expect(result).to eql "https://services.signin.education.gov.uk"
        end
      end

      context "when DSI_ENV is 'test'" do
        let(:env) { "test" }

        it "targets the test environment subdomains" do
          expect(result).to eql "https://test-services.signin.education.gov.uk"
        end
      end

      context "when DSI_ENV is 'staging'" do
        let(:env) { "staging" }

        it "targets the pre-production environment subdomains" do
          expect(result).to eql "https://pp-services.signin.education.gov.uk"
        end
      end
    end

    context "when DSI_ENV is unset" do
      context "and no params" do
        it "defaults to the production environment login page" do
          expect(result).to eql "https://services.signin.education.gov.uk"
        end
      end

      context "and subdomain" do
        subject(:service) { described_class.new(subdomain: subdomain) }

        describe "is profile" do
          let(:subdomain) { "profile" }

          it "targets the production environment user profile endpoint" do
            expect(result).to eql "https://profile.signin.education.gov.uk"
          end
        end

        describe "is oidc" do
          let(:subdomain) { "oidc" }

          it "targets the production environment OpenID Connect authentication endpoint" do
            expect(result).to eql "https://oidc.signin.education.gov.uk"
          end
        end

        describe "is api" do
          let(:subdomain) { "api" }

          it "targets the production environment API endpoint" do
            expect(result).to eql "https://api.signin.education.gov.uk"
          end
        end
      end

      context "and path" do
        subject(:service) { described_class.new(path: "/path/to/folder") }

        it "is appended" do
          expect(result).to eql "https://services.signin.education.gov.uk/path/to/folder"
        end
      end
    end
  end
end
