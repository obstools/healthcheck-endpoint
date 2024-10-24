# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::Error::Configuration::NotCallableService do
  subject(:error_instance) { described_class.new(service_name, services_setter) }

  let(:service_name) { random_service_name }
  let(:services_setter) { :some_services_setter= }

  it { expect(described_class).to be < ::ArgumentError }
  it { expect(error_instance).to be_an_instance_of(described_class) }

  it 'returns exception message context' do
    expect(error_instance.to_s).to eq(
      "Service #{service_name} is not callable. All values for #{services_setter} should be a callable objects"
    )
  end
end
