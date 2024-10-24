# frozen_string_literal: true

module HealthcheckEndpoint
  module Error
    module Configuration
      EnpointPattern = ::Class.new(::ArgumentError) do
        def initialize(arg_value, arg_name)
          super("#{arg_value} does not match a valid enpoint pattern for #{arg_name}")
        end
      end
    end
  end
end
