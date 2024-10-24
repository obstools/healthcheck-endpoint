# frozen_string_literal: true

module HealthcheckEndpoint
  class RackMiddleware
    def initialize(
      app,
      resolver = HealthcheckEndpoint::Resolver,
      counfigured = !!HealthcheckEndpoint.configuration
    )
      @app = app
      @resolver = resolver
      @counfigured = counfigured
    end

    def call(env)
      raise HealthcheckEndpoint::Error::Configuration::NotConfigured unless counfigured

      resolver.call(env) || app.call(env)
    end

    private

    attr_reader :app, :resolver, :counfigured
  end
end
