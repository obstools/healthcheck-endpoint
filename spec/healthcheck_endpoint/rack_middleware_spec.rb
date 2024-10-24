# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::RackMiddleware do
  subject(:middleware) { described_class.new(app, resolver).call(env) }

  let(:app_context) { 'some app rack response' }
  let(:app) { instance_double('RackApplication', call: app_context) }
  let(:resolver_context) { true }
  let(:resolver) { class_double('Resolver', call: resolver_context) }
  let(:env) { {} }

  context 'when HealthcheckEndpoint is configured' do
    before { init_configuration }

    context 'when resolver matches the route' do
      it 'returns rack response' do
        expect(resolver).to receive(:call).with(env)
        expect(middleware).to eq(resolver_context)
      end
    end

    context 'when resolver does not match the route' do
      let(:resolver_context) { nil }

      it 'returns rack response' do
        expect(resolver).to receive(:call).with(env)
        expect(app).to receive(:call).with(env)
        expect(middleware).to eq(app_context)
      end
    end
  end

  context 'when HealthcheckEndpoint is not configured' do
    it 'raises NotConfigured exception' do
      expect { middleware }.to raise_error(
        HealthcheckEndpoint::Error::Configuration::NotConfigured,
        'The configuration is empty. Please use HealthcheckEndpoint.configure before'
      )
    end
  end
end
