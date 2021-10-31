# frozen_string_literal: true

begin
  require 'simplecov'
  require 'simplecov-json'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter
  ]

  SimpleCov.start do
    enable_coverage :branch

    add_filter '/spec/'
  end

  unless ENV.key?('TEST_ENV_NUMBER') || ENV['DISABLE_MINIMUM_COVERAGE']
    # SimpleCov supports merging coverage results from parallel test runs,
    # but it doesn't support a global minimum coverage check when running in
    # parallel, so builds fail because subsets of the tests return < min%.
    SimpleCov.minimum_coverage(98)
    SimpleCov.maximum_coverage_drop(3)
    SimpleCov.minimum_coverage_by_file(78)
  end
rescue LoadError => e
  puts "Error: #{e}"
end
