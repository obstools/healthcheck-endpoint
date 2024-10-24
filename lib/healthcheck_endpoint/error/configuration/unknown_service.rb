# frozen_string_literal: true

module HealthcheckEndpoint
  module Error
    module Configuration
      UnknownService = ::Class.new(::ArgumentError) do
        def initialize(service_name, services_setter)
          super("Unknown #{service_name} service name for #{services_setter}. You should define it in config.services firstly")
        end
      end
    end
  end
end
