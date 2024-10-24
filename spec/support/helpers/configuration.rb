# frozen_string_literal: true

module HealthcheckEndpoint
  module RspecHelper
    module Configuration
      def configuration_block(**configuration_settings)
        lambda do |config|
          configuration_settings.each do |attribute, value|
            config.public_send(:"#{attribute}=", value)
          end
        end
      end

      def create_configuration(**configuration_settings)
        HealthcheckEndpoint::Configuration.new(&configuration_block(**configuration_settings))
      end

      def init_configuration(**args)
        HealthcheckEndpoint.configure(
          &configuration_block(
            **args
          )
        )
      end

      def current_configuration
        HealthcheckEndpoint.configuration
      end

      def reset_configuration
        HealthcheckEndpoint.reset_configuration!
      end
    end
  end
end
