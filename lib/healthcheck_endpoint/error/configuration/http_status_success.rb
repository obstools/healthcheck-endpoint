# frozen_string_literal: true

module HealthcheckEndpoint
  module Error
    module Configuration
      HttpStatusSuccess = ::Class.new(::ArgumentError) do
        def initialize(arg_value, arg_name)
          super("Status #{arg_value} is wrong HTTP successful status for #{arg_name}. It should be in the range 200-226")
        end
      end
    end
  end
end
