# frozen_string_literal: true

RSpec.describe HealthcheckEndpoint::RspecHelper::ContextGenerator, type: :helper do
  describe '#random_message' do
    it 'returns random message' do
      expect(::FFaker::Lorem).to receive(:sentence).and_call_original
      expect(random_message).to be_an_instance_of(::String)
    end
  end

  describe '#random_service_name' do
    it 'returns random service name' do
      expect(::FFaker::InternetSE).to receive(:login_user_name).and_call_original
      expect(random_service_name).to be_an_instance_of(::String)
    end
  end

  describe '#random_endpoint' do
    it 'returns random endpoint' do
      expect(::FFaker::InternetSE).to receive(:login_user_name).and_call_original
      expect(random_endpoint).to match(%r{\A/.*\z})
    end
  end

  describe '#random_http_status' do
    context 'when successful status' do
      it 'returns random successful http status' do
        expect(random_http_status(successful: true)).to be_between(200, 226)
      end
    end

    context 'when failure status' do
      it 'returns random failure http status' do
        expect(random_http_status(successful: false)).to be_between(500, 511)
      end
    end
  end

  describe '#create_service' do
    subject(:builded_service) { create_service(service_name, successful: service_type) }

    let(:service_name) { random_service_name }

    shared_examples 'returns hash with service' do
      it 'returns hash with service' do
        expect(builded_service.transform_values(&:call)).to eq(service_name => service_type)
      end
    end

    context 'when successful service' do
      let(:service_type) { true }

      include_examples 'returns hash with service'
    end

    context 'when failed service' do
      let(:service_type) { false }

      include_examples 'returns hash with service'
    end
  end
end
