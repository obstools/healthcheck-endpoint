# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint do
  let(:service_name) { create_service(random_service_name) }
  let(:services) { create_service(service_name) }
  let(:services_startup) { [service_name] }
  let(:services_liveness) { [service_name] }
  let(:services_readiness) { [service_name] }
  let(:endpoints_namespace) { random_endpoint }
  let(:endpoint_startup) { random_endpoint }
  let(:endpoint_liveness) { random_endpoint }
  let(:endpoint_readiness) { random_endpoint }
  let(:endpoint_startup_status_success) { random_http_status(successful: true) }
  let(:endpoint_liveness_status_success) { random_http_status(successful: true) }
  let(:endpoint_readiness_status_success) { random_http_status(successful: true) }
  let(:endpoint_startup_status_failure) { random_http_status(successful: false) }
  let(:endpoint_liveness_status_failure) { random_http_status(successful: false) }
  let(:endpoint_readiness_status_failure) { random_http_status(successful: false) }

  describe '.configure' do
    subject(:configuration) { described_class.configure(&config_block) }

    let(:config_block) { nil }

    context 'without block' do
      it 'sets default attributes into configuration instance' do
        expect { configuration }
          .to change(described_class, :configuration)
          .from(nil)
          .to(be_instance_of(HealthcheckEndpoint::Configuration))
        expect(configuration).to be_an_instance_of(HealthcheckEndpoint::Configuration)
        expect(configuration.services).to eq({})
        expect(configuration.services_startup).to eq([])
        expect(configuration.services_liveness).to eq([])
        expect(configuration.services_readiness).to eq([])
        expect(configuration.endpoints_namespace).to eq(HealthcheckEndpoint::Configuration::ENDPOINTS_NAMESPACE)
        expect(configuration.endpoint_startup).to eq(HealthcheckEndpoint::Configuration::ENDPOINT_STARTUP)
        expect(configuration.endpoint_liveness).to eq(HealthcheckEndpoint::Configuration::ENDPOINT_LIVENESS)
        expect(configuration.endpoint_readiness).to eq(HealthcheckEndpoint::Configuration::ENDPOINT_READINESS)
        expect(configuration.endpoint_startup_status_success).to eq(HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_SUCCESS)
        expect(configuration.endpoint_liveness_status_success).to eq(HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_SUCCESS)
        expect(configuration.endpoint_readiness_status_success).to eq(HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_SUCCESS)
        expect(configuration.endpoint_startup_status_failure).to eq(HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_FAILURE)
        expect(configuration.endpoint_liveness_status_failure).to eq(HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_FAILURE)
        expect(configuration.endpoint_readiness_status_failure).to eq(HealthcheckEndpoint::Configuration::DEFAULT_HTTP_STATUS_FAILURE)
      end
    end

    context 'with block' do
      let(:config_block) do
        configuration_block(
          services: services,
          services_startup: services_startup,
          services_liveness: services_liveness,
          services_readiness: services_readiness,
          endpoints_namespace: endpoints_namespace,
          endpoint_startup: endpoint_startup,
          endpoint_liveness: endpoint_liveness,
          endpoint_readiness: endpoint_readiness,
          endpoint_startup_status_success: endpoint_startup_status_success,
          endpoint_liveness_status_success: endpoint_liveness_status_success,
          endpoint_readiness_status_success: endpoint_readiness_status_success,
          endpoint_startup_status_failure: endpoint_startup_status_failure,
          endpoint_liveness_status_failure: endpoint_liveness_status_failure,
          endpoint_readiness_status_failure: endpoint_readiness_status_failure
        )
      end

      it 'sets attributes into configuration instance' do
        expect { configuration }
          .to change(described_class, :configuration)
          .from(nil)
          .to(be_instance_of(HealthcheckEndpoint::Configuration))
        expect(configuration).to be_an_instance_of(HealthcheckEndpoint::Configuration)
        expect(configuration.services).to eq(services)
        expect(configuration.services_startup).to eq(services_startup)
        expect(configuration.services_liveness).to eq(services_liveness)
        expect(configuration.services_readiness).to eq(services_readiness)
        expect(configuration.endpoints_namespace).to eq(endpoints_namespace)
        expect(configuration.endpoint_startup).to eq(endpoint_startup)
        expect(configuration.endpoint_liveness).to eq(endpoint_liveness)
        expect(configuration.endpoint_readiness).to eq(endpoint_readiness)
        expect(configuration.endpoint_startup_status_success).to eq(endpoint_startup_status_success)
        expect(configuration.endpoint_liveness_status_success).to eq(endpoint_liveness_status_success)
        expect(configuration.endpoint_readiness_status_success).to eq(endpoint_readiness_status_success)
        expect(configuration.endpoint_startup_status_failure).to eq(endpoint_startup_status_failure)
        expect(configuration.endpoint_liveness_status_failure).to eq(endpoint_liveness_status_failure)
        expect(configuration.endpoint_readiness_status_failure).to eq(endpoint_readiness_status_failure)
      end
    end
  end

  describe '.reset_configuration!' do
    before do
      described_class.configure(
        &configuration_block(
          services: services,
          services_startup: services_startup,
          services_liveness: services_liveness,
          services_readiness: services_readiness,
          endpoints_namespace: endpoints_namespace,
          endpoint_startup: endpoint_startup,
          endpoint_liveness: endpoint_liveness,
          endpoint_readiness: endpoint_readiness,
          endpoint_startup_status_success: endpoint_startup_status_success,
          endpoint_liveness_status_success: endpoint_liveness_status_success,
          endpoint_readiness_status_success: endpoint_readiness_status_success,
          endpoint_startup_status_failure: endpoint_startup_status_failure,
          endpoint_liveness_status_failure: endpoint_liveness_status_failure,
          endpoint_readiness_status_failure: endpoint_readiness_status_failure
        )
      )
    end

    it do
      expect { described_class.reset_configuration! }
        .to change(described_class, :configuration)
        .from(be_instance_of(HealthcheckEndpoint::Configuration)).to(nil)
    end
  end

  describe '.configuration' do
    subject(:configuration) { described_class.configuration }

    before do
      described_class.configure(&configuration_block(
        services: services,
        services_startup: services_startup,
        services_liveness: services_liveness,
        services_readiness: services_readiness,
        endpoints_namespace: endpoints_namespace,
        endpoint_startup: endpoint_startup,
        endpoint_liveness: endpoint_liveness,
        endpoint_readiness: endpoint_readiness,
        endpoint_startup_status_success: endpoint_startup_status_success,
        endpoint_liveness_status_success: endpoint_liveness_status_success,
        endpoint_readiness_status_success: endpoint_readiness_status_success,
        endpoint_startup_status_failure: endpoint_startup_status_failure,
        endpoint_liveness_status_failure: endpoint_liveness_status_failure,
        endpoint_readiness_status_failure: endpoint_readiness_status_failure
      ))
    end

    it 'returns configuration instance' do
      expect(configuration).to be_instance_of(HealthcheckEndpoint::Configuration)
      expect(configuration.services).to eq(services)
      expect(configuration.services_startup).to eq(services_startup)
      expect(configuration.services_liveness).to eq(services_liveness)
      expect(configuration.services_readiness).to eq(services_readiness)
      expect(configuration.endpoints_namespace).to eq(endpoints_namespace)
      expect(configuration.endpoint_startup).to eq(endpoint_startup)
      expect(configuration.endpoint_liveness).to eq(endpoint_liveness)
      expect(configuration.endpoint_readiness).to eq(endpoint_readiness)
      expect(configuration.endpoint_startup_status_success).to eq(endpoint_startup_status_success)
      expect(configuration.endpoint_liveness_status_success).to eq(endpoint_liveness_status_success)
      expect(configuration.endpoint_readiness_status_success).to eq(endpoint_readiness_status_success)
      expect(configuration.endpoint_startup_status_failure).to eq(endpoint_startup_status_failure)
      expect(configuration.endpoint_liveness_status_failure).to eq(endpoint_liveness_status_failure)
      expect(configuration.endpoint_readiness_status_failure).to eq(endpoint_readiness_status_failure)
    end
  end
end
