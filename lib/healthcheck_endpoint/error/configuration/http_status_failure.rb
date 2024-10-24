# frozen_string_literal: true

module HealthcheckEndpoint
  module Error
    module Configuration
      HttpStatusFailure = ::Class.new(::ArgumentError) do
        def initialize(arg_value, arg_name)
          super("Status #{arg_value} is wrong HTTP failure status for #{arg_name}. It should be in the range 500-511")
        end
      end
    end
  end
end
