# frozen_string_literal: true

RSpec.describe OnStrum::Healthcheck::Error::UnknownService do
  subject(:error_instance) { described_class.new(service_name, services_setter) }

  let(:service_name) { random_service_name }
  let(:services_setter) { :some_services_setter= }

  it { expect(described_class).to be < ::StandardError }
  it { expect(error_instance).to be_an_instance_of(described_class) }

  it 'returns exception message context' do
    expect(error_instance.to_s).to eq(
      "Unknown #{service_name} service name for #{services_setter}. You should define it in config.services firstly"
    )
  end
end
