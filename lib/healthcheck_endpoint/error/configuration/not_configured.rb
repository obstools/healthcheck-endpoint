# frozen_string_literal: true

module HealthcheckEndpoint
  module Error
    module Configuration
      NotConfigured = ::Class.new(::RuntimeError) do
        def initialize
          super('The configuration is empty. Please use HealthcheckEndpoint.configure before')
        end
      end
    end
  end
end
