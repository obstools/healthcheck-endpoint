# frozen_string_literal: true

module HealthcheckEndpoint
  module Error
    module Configuration
      ArgumentType = ::Class.new(::ArgumentError) do
        def initialize(arg_value, arg_name)
          super("#{arg_value} is not a valid #{arg_name}")
        end
      end
    end
  end
end
