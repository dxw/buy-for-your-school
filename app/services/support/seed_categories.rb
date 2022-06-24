require "yaml"
require "dry-initializer"
require "types"

module Support
  #
  # Persist (Sub)Categories from YAML file
  #
  # @example
  #   SeedCategories.new(data: "/path/to/file.yml").call
  #
  class SeedCategories
    extend Dry::Initializer

    # @!attribute [r] data
    # @return [String] (defaults to ./config/support/categories.yml)
    option :data, Types::String, default: proc { "./config/support/categories.yml" }
    # @!attribute [r] reset
    # @return [Boolean] (defaults to false)
    option :reset, Types::Bool, default: proc { false }

    # @return [Array<Hash>]
    #
    def call
      Category.destroy_all if reset

      YAML.load_file(data).each do |group|
        category = Support::Category.top_level.find_or_create_by!(title: group["title"]) do |cat|
          cat.description = group["description"]
          cat.slug = group["slug"]
        end

        group["sub_categories"].each do |sub_group|
          sub_category = category.sub_categories.find_or_create_by!(title: sub_group["title"])
          sub_category.description = sub_group["description"]
          sub_category.slug = sub_group["slug"]
          sub_category.tower = sub_group["tower"]
          sub_category.save!
        end
      end
    end
  end
end
