# Retrieve Page entries from Contentful
#
class Content::Page::Get
  extend Dry::Initializer

  # @!attribute [r] entry_id
  #   @return [String]
  option :entry_id, Types::String
  # @!attribute [r] client
  #   @return [Content::Client]
  option :client, default: proc { Content::Client.new }

  # @return [Contentful::Entry, Symbol]
  def call
    page = client.by_id(entry_id)

    if page.nil?
      send_rollbar_error(message: "A Contentful page entry was not found")
      return :not_found
    end

    page
  end

private

  def send_rollbar_error(message:)
    Rollbar.error(
      message,
      contentful_space_id: client.space,
      contentful_environment: client.environment,
      contentful_url: client.api_url,
      contentful_entry_id: entry_id,
    )
  end
end
