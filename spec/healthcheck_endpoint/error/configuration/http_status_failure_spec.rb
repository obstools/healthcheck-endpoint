# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::Error::Configuration::HttpStatusFailure do
  subject(:error_instance) { described_class.new(arg_value, arg_name) }

  let(:arg_value) { random_http_status(successful: false) }
  let(:arg_name) { :some_arg_name }

  it { expect(described_class).to be < ::ArgumentError }
  it { expect(error_instance).to be_an_instance_of(described_class) }

  it 'returns exception message context' do
    expect(error_instance.to_s).to eq(
      "Status #{arg_value} is wrong HTTP failure status for #{arg_name}. It should be in the range 500-511"
    )
  end
end
