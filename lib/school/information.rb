require "dry-initializer"
require "csv"

require "types"
require "downloader"
require "school/mapper"
require "school/schema"

module School
  # "GIAS" formerly called "Edubase"
  GIAS_URL = "https://ea-edubase-api-prod.azurewebsites.net/edubase/downloads/public".freeze

  # Batch process data from "Get Information About Schools"
  #   1. use local file or download
  #   2. filter by column and values
  #   3. transform data structure
  #   4. coerce and validate tuples
  #   5. pass to optional function
  #
  class Information
    extend Dry::Initializer

    # @!attribute file
    #   @return [nil, String, File] optional path to CSV data
    option :file, optional: true, type: ::Types::Nil | ::Types.Constructor(File)

    # @!attribute filter
    #   @return [Hash] "column header" => [integer, values]
    option :filter, optional: true, type: ::Types::Strict::Hash

    # @see Exporter
    # @see School::RecordKeeper
    #
    # @!attribute exporter
    #   @return [Proc]
    option :exporter, default: proc { ->(x = nil) { x } }

    # Restricts how much memory is consumed by data manipulation
    #
    # @!attribute batch_size
    #   @return [Integer] iterate over records in batches
    option :batch_size, default: proc { 1_000 }, type: ::Types::Strict::Integer

    # @!attribute mapper
    option :mapper, default: proc { Mapper.new }

    # @!attribute schema
    option :schema, default: proc { Schema.new }

    # @!attribute downloader
    option :downloader, default: proc { ::Downloader.new }

    # @return [Array<Hash>]
    def call
      output = []

      data.each_slice(batch_size) do |rows|
        dataset = process(rows)
        output << dataset # if we wish to return the entries (kept to keep specs passing)
        exporter.call dataset
      end

      output.flatten
    end

  private

    # @return [Array<Hash>] transformed and coerced data
    def process(rows)
      mapper.call(rows).map { |row| schema.call(row).to_h }
    end

    # @return [Enumerator::Lazy]
    def data
      filter ? filtered_rows : all_rows
    end

    # @return [Enumerator::Lazy] table rows
    def all_rows
      CSV.foreach(data_file.path, headers: true, encoding: "ISO-8859-1:UTF-8").lazy
    end

    # Converts "01" to 1
    #
    # @return [Enumerator::Lazy] filter rows by codes
    def filtered_rows
      all_rows.select do |row|
        # OPTIMIZE: filter GIAS data by any column not just codes
        filter.any? { |key, values| values.include?(row[key].to_i) }
      end
    end

    # @return [File] existing or downloaded data
    def data_file
      file || downloader.call(gias_csv_url)
    end

    # @return [String] url to GIAS public data in CSV format
    def gias_csv_url
      "#{GIAS_URL}/edubasealldata#{date_format}.csv"
    end

    # @return [String] current date "20211014"
    def date_format
      Time.zone.now.strftime("%Y%m%d")
    end
  end
end
