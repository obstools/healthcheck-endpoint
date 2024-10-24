# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::Error::Configuration::NotConfigured do
  subject(:error_instance) { described_class.new }

  it { expect(described_class).to be < ::RuntimeError }
  it { expect(error_instance).to be_an_instance_of(described_class) }

  it 'returns exception message context' do
    expect(error_instance.to_s).to eq(
      'The configuration is empty. Please use HealthcheckEndpoint.configure before'
    )
  end
end
