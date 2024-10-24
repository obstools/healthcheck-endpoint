# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::Configuration do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:ATTRIBUTES) }
    it { expect(described_class).to be_const_defined(:ENDPOINTS_NAMESPACE) }
    it { expect(described_class).to be_const_defined(:ENDPOINT_STARTUP) }
    it { expect(described_class).to be_const_defined(:ENDPOINT_LIVENESS) }
    it { expect(described_class).to be_const_defined(:ENDPOINT_READINESS) }
    it { expect(described_class).to be_const_defined(:DEFAULT_HTTP_STATUS_SUCCESS) }
    it { expect(described_class).to be_const_defined(:DEFAULT_HTTP_STATUS_FAILURE) }
    it { expect(described_class).to be_const_defined(:AVILABLE_HTTP_STATUSES_SUCCESS) }
    it { expect(described_class).to be_const_defined(:AVILABLE_HTTP_STATUSES_FAILURE) }
  end

  describe HealthcheckEndpoint::Configuration::Settings do
    describe '#update' do
      subject(:updated_settings) { described_class.new.update(&block) }

      context 'when configuration block has been passed' do
        let(:block) { ->(config) { config.services = 42 } }

        it 'updates structure' do
          expect(updated_settings).to be_an_instance_of(described_class)
          expect(updated_settings.services).to eq(42)
        end
      end

      context 'when configuration block has not been passed' do
        let(:block) { nil }

        it 'does not update structure' do
          expect(updated_settings).to be_an_instance_of(described_class)
          expect(updated_settings.services).to be_nil
        end
      end
    end
  end

  describe '.new' do
    subject(:configuration) do
      create_configuration(
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

    context 'when valid configuration' do
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

      it 'creates configuration instance' do
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
        expect(configuration).to be_an_instance_of(described_class)
      end
    end

    context 'when invalid configuration' do
      shared_examples 'raies argument error' do
        it 'raies argument error' do
          expect { configuration }.to raise_error(
            target_exception_class,
            expected_error_message
          )
        end
      end

      let(:invalid_argument) { 42 }

      context 'when services= setter is invalid' do
        context 'when argument has wrong type' do
          subject(:configuration) do
            create_configuration(services: invalid_argument)
          end

          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::ArgumentType }
          let(:expected_error_message) { "#{invalid_argument} is not a valid services=" }

          include_examples 'raies argument error'
        end

        context 'when argument nested value is not a callable object' do
          subject(:configuration) do
            create_configuration(services: { service_name => invalid_argument })
          end

          let(:service_name) { random_service_name }
          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::NotCallableService }
          let(:expected_error_message) do
            "Service #{service_name} is not callable. All values for services= should be a callable objects"
          end

          include_examples 'raies argument error'
        end
      end

      context 'when services_startup= setter is invalid' do
        context 'when argument has wrong type' do
          subject(:configuration) do
            create_configuration(services_startup: invalid_argument)
          end

          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::ArgumentType }
          let(:expected_error_message) { "#{invalid_argument} is not a valid services_startup=" }

          include_examples 'raies argument error'
        end

        context 'when argument nested value is not a defined service' do
          subject(:configuration) do
            create_configuration(services_startup: [invalid_argument])
          end

          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::UnknownService }
          let(:expected_error_message) do
            "Unknown #{invalid_argument} service name for services_startup=. You should define it in config.services firstly"
          end

          include_examples 'raies argument error'
        end
      end

      context 'when services_liveness= setter is invalid' do
        context 'when argument has wrong type' do
          subject(:configuration) do
            create_configuration(services_liveness: invalid_argument)
          end

          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::ArgumentType }
          let(:expected_error_message) { "#{invalid_argument} is not a valid services_liveness=" }

          include_examples 'raies argument error'
        end

        context 'when argument nested value is not a defined service' do
          subject(:configuration) do
            create_configuration(services_liveness: [invalid_argument])
          end

          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::UnknownService }
          let(:expected_error_message) do
            "Unknown #{invalid_argument} service name for services_liveness=. You should define it in config.services firstly"
          end

          include_examples 'raies argument error'
        end
      end

      context 'when services_readiness= setter is invalid' do
        context 'when argument has wrong type' do
          subject(:configuration) do
            create_configuration(services_readiness: invalid_argument)
          end

          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::ArgumentType }
          let(:expected_error_message) { "#{invalid_argument} is not a valid services_readiness=" }

          include_examples 'raies argument error'
        end

        context 'when argument nested value is not a defined service' do
          subject(:configuration) do
            create_configuration(services_readiness: [invalid_argument])
          end

          let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::UnknownService }
          let(:expected_error_message) do
            "Unknown #{invalid_argument} service name for services_readiness=. You should define it in config.services firstly"
          end

          include_examples 'raies argument error'
        end
      end

      HealthcheckEndpoint::Configuration::ATTRIBUTES[4..7].each do |endpoint_setter|
        context "when #{endpoint_setter}= setter is invalid" do
          context 'when argument has wrong type' do
            subject(:configuration) do
              create_configuration(endpoint_setter => invalid_argument)
            end

            let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::ArgumentType }
            let(:expected_error_message) { "#{invalid_argument} is not a valid #{endpoint_setter}=" }

            include_examples 'raies argument error'
          end

          context 'when argument is not match to enpoint pattern' do
            subject(:configuration) do
              create_configuration(endpoint_setter => endpoint)
            end

            let(:endpoint) { invalid_argument.to_s }
            let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::EnpointPattern }
            let(:expected_error_message) do
              "#{endpoint} does not match a valid enpoint pattern for #{endpoint_setter}="
            end

            include_examples 'raies argument error'
          end
        end
      end

      HealthcheckEndpoint::Configuration::ATTRIBUTES[8..10].each do |endpoint_setter|
        context "when #{endpoint_setter}= setter is invalid" do
          context 'when argument has wrong type' do
            subject(:configuration) do
              create_configuration(endpoint_setter => invalid_argument.to_s)
            end

            let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::ArgumentType }
            let(:expected_error_message) { "#{invalid_argument} is not a valid #{endpoint_setter}=" }

            include_examples 'raies argument error'
          end

          context 'when argument is not match to enpoint pattern' do
            subject(:configuration) do
              create_configuration(endpoint_setter => invalid_argument)
            end

            let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::HttpStatusSuccess }
            let(:expected_error_message) do
              "Status #{invalid_argument} is wrong HTTP successful status for #{endpoint_setter}=. It should be in the range 200-226"
            end

            include_examples 'raies argument error'
          end
        end
      end

      HealthcheckEndpoint::Configuration::ATTRIBUTES[11..13].each do |endpoint_setter|
        context "when #{endpoint_setter}= setter is invalid" do
          context 'when argument has wrong type' do
            subject(:configuration) do
              create_configuration(endpoint_setter => invalid_argument.to_s)
            end

            let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::ArgumentType }
            let(:expected_error_message) { "#{invalid_argument} is not a valid #{endpoint_setter}=" }

            include_examples 'raies argument error'
          end

          context 'when argument is not match to enpoint pattern' do
            subject(:configuration) do
              create_configuration(endpoint_setter => invalid_argument)
            end

            let(:target_exception_class) { HealthcheckEndpoint::Error::Configuration::HttpStatusFailure }
            let(:expected_error_message) do
              "Status #{invalid_argument} is wrong HTTP failure status for #{endpoint_setter}=. It should be in the range 500-511"
            end

            include_examples 'raies argument error'
          end
        end
      end
    end
  end
end
