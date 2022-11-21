require 'simplecov'

SimpleCov.collate Dir["coverage-*/.resultset.json"], 'rails' do
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::SimpleFormatter,
    SimpleCov::Formatter::HTMLFormatter
  ])
end
