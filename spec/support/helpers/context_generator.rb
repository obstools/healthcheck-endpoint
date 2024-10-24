# frozen_string_literal: true

module HealthcheckEndpoint
  module RspecHelper
    module ContextGenerator
      def random_message
        ::FFaker::Lorem.sentence
      end

      def random_service_name
        ::FFaker::InternetSE.login_user_name
      end

      def random_endpoint
        "/#{random_service_name}"
      end

      def random_http_status(successful:)
        (successful ? 200..226 : 500..511).to_a.sample
      end

      def create_service(service_name, successful: true)
        { service_name => -> { successful } }
      end
    end
  end
end
