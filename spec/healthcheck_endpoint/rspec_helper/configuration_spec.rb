# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::RspecHelper::Configuration, type: :helper do
  describe '#configuration_block' do
    let(:configuration_params) { { param_one: 1, param_two: 2 } }
    let(:configuration_instance) { ::Struct.new(*configuration_params.keys).new }

    before { configuration_block(**configuration_params).call(configuration_instance) }

    it { expect(configuration_block).to be_an_instance_of(::Proc) }

    it 'sets configuration instance attributes' do
      configuration_params.each do |attribute, value|
        expect(configuration_instance.public_send(attribute)).to eq(value)
      end
    end
  end

  describe '#create_configuration' do
    subject(:configuration_builder) do
      create_configuration(
        services: services,
        services_startup: %i[a]
      )
    end

    let(:services) { { a: -> {} } }
    let(:services_startup) { %i[a] }

    it 'returns configuration instance with defined params' do
      expect(configuration_builder).to be_an_instance_of(HealthcheckEndpoint::Configuration)
      expect(configuration_builder.services).to eq(services)
      expect(configuration_builder.services_startup).to eq(services_startup)
    end
  end

  describe '#init_configuration' do
    subject(:configuration_initializer) { init_configuration(endpoints_namespace: endpoints_namespace) }

    let(:endpoints_namespace) { '/some_endpoint' }

    it 'initializes configuration instance with random and predefined params' do
      expect(configuration_initializer).to be_an_instance_of(HealthcheckEndpoint::Configuration)
      expect(configuration_initializer.endpoints_namespace).to eq(endpoints_namespace)
    end
  end

  describe '#current_configuration' do
    subject(:current_configuration_instance) { current_configuration }

    it do
      expect(HealthcheckEndpoint).to receive(:configuration)
      current_configuration_instance
    end
  end

  describe '#reset_configuration' do
    subject(:reset_current_configuration) { reset_configuration }

    it do
      expect(HealthcheckEndpoint).to receive(:reset_configuration!)
      reset_current_configuration
    end
  end
end
