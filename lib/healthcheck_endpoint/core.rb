# frozen_string_literal: true

module HealthcheckEndpoint
  module Error
    module Configuration
      require_relative 'error/configuration/argument_type'
      require_relative 'error/configuration/unknown_service'
      require_relative 'error/configuration/not_callable_service'
      require_relative 'error/configuration/enpoint_pattern'
      require_relative 'error/configuration/http_status_success'
      require_relative 'error/configuration/http_status_failure'
      require_relative 'error/configuration/not_configured'
    end
  end

  require_relative 'version'
  require_relative 'configuration'
  require_relative 'resolver'
  require_relative 'rack_middleware'
end
