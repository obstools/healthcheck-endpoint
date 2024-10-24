# frozen_string_literal: true

module HealthcheckEndpoint
  class Configuration
    ATTRIBUTES = %i[
      services
      services_startup
      services_liveness
      services_readiness
      endpoints_namespace
      endpoint_startup
      endpoint_liveness
      endpoint_readiness
      endpoint_startup_status_success
      endpoint_liveness_status_success
      endpoint_readiness_status_success
      endpoint_startup_status_failure
      endpoint_liveness_status_failure
      endpoint_readiness_status_failure
    ].freeze
    ENDPOINTS_NAMESPACE = '/healthcheck'
    ENDPOINT_STARTUP = '/startup'
    ENDPOINT_LIVENESS = '/liveness'
    ENDPOINT_READINESS = '/readiness'
    DEFAULT_HTTP_STATUS_SUCCESS = 200
    DEFAULT_HTTP_STATUS_FAILURE = 500
    AVILABLE_HTTP_STATUSES_SUCCESS = (DEFAULT_HTTP_STATUS_SUCCESS..226).freeze
    AVILABLE_HTTP_STATUSES_FAILURE = (DEFAULT_HTTP_STATUS_FAILURE..511).freeze

    Settings = ::Struct.new(*HealthcheckEndpoint::Configuration::ATTRIBUTES, keyword_init: true) do
      def update(&block)
        return self unless block

        tap(&block)
      end
    end

    attr_reader(*HealthcheckEndpoint::Configuration::ATTRIBUTES)

    def initialize(&block)
      configuration_settings = build_configuration_settings(&block)
      HealthcheckEndpoint::Configuration::ATTRIBUTES.each do |attribute|
        public_send(:"#{attribute}=", configuration_settings.public_send(attribute))
      end
    end

    HealthcheckEndpoint::Configuration::ATTRIBUTES.each do |attribute|
      define_method(:"#{attribute}=") do |argument|
        validate_attribute(__method__, attribute, argument)
        instance_variable_set(:"@#{attribute}", argument)
      end
    end

    private

    def build_configuration_settings(&block) # rubocop:disable Metrics/MethodLength
      HealthcheckEndpoint::Configuration::Settings.new(
        services: {},
        services_startup: [],
        services_liveness: [],
        services_readiness: [],
        endpoints_namespace: HealthcheckEndpoint::Configuration::ENDPOINTS_NAMESPACE,
        endpoint_startup: HealthcheckEndpoint::Configuration::ENDPOINT_STARTUP,
        endpoint_liveness: HealthcheckEndpoint::Configuration::ENDPOINT_LIVENESS,
        endpoint_readiness: HealthcheckEndpoint::Configuration::ENDPOINT_READINESS,
        endpoint_startup_status_success: HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_SUCCESS,
        endpoint_liveness_status_success: HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_SUCCESS,
        endpoint_readiness_status_success: HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_SUCCESS,
        endpoint_startup_status_failure: HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_FAILURE,
        endpoint_liveness_status_failure: HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_FAILURE,
        endpoint_readiness_status_failure: HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_FAILURE
      ).update(&block)
    end

    def validate_attribute(method, attribute, value) # rubocop:disable Metrics/AbcSize
      raise_unless(HealthcheckEndpoint::Error::Configuration::ArgumentType, method, *validator_argument_type(attribute, value))
      case attribute
      when HealthcheckEndpoint::Configuration::ATTRIBUTES[0]
        raise_unless(HealthcheckEndpoint::Error::Configuration::NotCallableService, method, *validator_services_callable(value))
      when *HealthcheckEndpoint::Configuration::ATTRIBUTES[1..3]
        raise_unless(HealthcheckEndpoint::Error::Configuration::UnknownService, method, *validator_services_conformity(value))
      when *HealthcheckEndpoint::Configuration::ATTRIBUTES[4..7]
        raise_unless(HealthcheckEndpoint::Error::Configuration::EnpointPattern, method, *validator_endpoint(value))
      when *HealthcheckEndpoint::Configuration::ATTRIBUTES[8..10]
        raise_unless(HealthcheckEndpoint::Error::Configuration::HttpStatusSuccess, method, *validator_http_status_success(value))
      when *HealthcheckEndpoint::Configuration::ATTRIBUTES[11..13]
        raise_unless(HealthcheckEndpoint::Error::Configuration::HttpStatusFailure, method, *validator_http_status_failure(value))
      end
    end

    def validator_argument_type(method_name, argument)
      [
        argument,
        argument.is_a?(
          case method_name
          when :services then ::Hash
          when *HealthcheckEndpoint::Configuration::ATTRIBUTES[1..3] then ::Array
          when *HealthcheckEndpoint::Configuration::ATTRIBUTES[4..7] then ::String
          when *HealthcheckEndpoint::Configuration::ATTRIBUTES[8..13] then ::Integer
          end
        )
      ]
    end

    def validator_endpoint(argument)
      [argument, argument[%r{\A/.*\z}]]
    end

    def validator_http_status_success(argument)
      [argument, HealthcheckEndpoint::Configuration::AVILABLE_HTTP_STATUSES_SUCCESS.include?(argument)]
    end

    def validator_http_status_failure(argument)
      [argument, HealthcheckEndpoint::Configuration::AVILABLE_HTTP_STATUSES_FAILURE.include?(argument)]
    end

    def validator_services_callable(services_to_check, target_service = nil)
      result = services_to_check.all? do |service_name, service_context|
        target_service = service_name
        service_context.respond_to?(:call)
      end

      [target_service, result]
    end

    def validator_services_conformity(services_to_check, target_service = nil)
      result = services_to_check.all? do |service_name|
        target_service = service_name
        services.key?(service_name)
      end

      [target_service, result]
    end

    def raise_unless(exception_class, argument_name, argument_context, condition)
      raise exception_class.new(argument_context, argument_name) unless condition
    end
  end
end
