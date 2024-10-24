# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::Resolver do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:PROBE_ENDPOINTS) }
    it { expect(described_class).to be_const_defined(:CONTENT_TYPE) }
    it { expect(described_class).to be_const_defined(:ROOT_NAMESPACE) }
  end

  describe '.call' do
    subject(:resolver) do
      described_class.call(
        Rack::MockRequest.env_for.merge('PATH_INFO' => healthcheck_endpoint)
      )
    end

    let(:service_status_first) { true }
    let(:service_name_second) { random_service_name }
    let(:service_name_first) { random_service_name }

    context 'when unknown endpoint' do
      let(:healthcheck_endpoint) { '/unknown_endpoint' }

      before { init_configuration }

      it { is_expected.to be_nil }
    end

    %i[startup liveness readiness].each do |probe_name|
      context "when #{probe_name} root endpoint" do
        let(:service_status_second) { true }
        let(:healthcheck_endpoint) { current_configuration.public_send(:"endpoint_#{probe_name}") }

        before do
          init_configuration(
            services: { service_name_first => -> { service_status_first } },
            "services_#{probe_name}": [service_name_first],
            endpoints_namespace: '/'
          )
        end

        it 'returns rack middleware response' do
          response_status, _content_type, response_body = resolver

          expect(response_status).to eq(
            current_configuration.public_send(:"endpoint_#{probe_name}_status_success")
          )
          expect(response_body.first).to include("application-#{probe_name}-healthcheck")
        end
      end

      context "when #{probe_name} endpoint" do
        [true, false].each do |status| # rubocop:disable Performance/CollectionLiteralInLoop
          context "when successful status is #{status}" do
            let(:service_status_second) { status }
            let(:healthcheck_endpoint) do
              endpoint = current_configuration.public_send(:"endpoint_#{probe_name}")
              "#{current_configuration.endpoints_namespace}#{endpoint}"
            end

            before do
              init_configuration(
                services: {
                  service_name_first => -> { service_status_first },
                  service_name_second => -> { service_status_second }
                },
                "services_#{probe_name}": [
                  service_name_first,
                  service_name_second
                ]
              )
            end

            it 'returns rack middleware response' do
              response_status, content_type, response = resolver
              response_body, target_status = response.first, "endpoint_#{probe_name}_status_#{status ? 'success' : 'failure'}"
              expected_probe_status = current_configuration.public_send(target_status)

              expect(response_status).to eq(expected_probe_status)
              expect(content_type).to eq('Content-Type' => 'application/json')
              expect(::JSON.parse(response_body).dig('data', 'attributes')).to eq(
                service_name_first => service_status_first,
                service_name_second => service_status_second
              )
              expect(response_body).to match_json_schema('jsonapi_response')
            end
          end
        end
      end
    end
  end
end
