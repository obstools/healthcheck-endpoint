# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::Error::Configuration::ArgumentType do
  subject(:error_instance) { described_class.new(arg_value, arg_name) }

  let(:arg_value) { random_message }
  let(:arg_name) { :some_arg_name }

  it { expect(described_class).to be < ::ArgumentError }
  it { expect(error_instance).to be_an_instance_of(described_class) }
  it { expect(error_instance.to_s).to eq("#{arg_value} is not a valid #{arg_name}") }
end
