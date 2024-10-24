# ![HealthcheckEndpoint - Simple configurable application healthcheck rack middleware](https://repository-images.githubusercontent.com/769335579/012755ac-8757-43b1-8191-7cac167396fa)

[![Maintainability](https://api.codeclimate.com/v1/badges/e1da0941cf2234c1d110/maintainability)](https://codeclimate.com/github/obstools/healthcheck-endpoint/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e1da0941cf2234c1d110/test_coverage)](https://codeclimate.com/github/obstools/healthcheck-endpoint/test_coverage)
[![CircleCI](https://circleci.com/gh/obstools/healthcheck-endpoint/tree/master.svg?style=svg)](https://circleci.com/gh/obstools/healthcheck-endpoint/tree/master)
[![Gem Version](https://badge.fury.io/rb/healthcheck_endpoint.svg)](https://badge.fury.io/rb/healthcheck_endpoint)
[![Downloads](https://img.shields.io/gem/dt/healthcheck_endpoint.svg?colorA=004d99&colorB=0073e6)](https://rubygems.org/gems/healthcheck_endpoint)
[![GitHub](https://img.shields.io/github/license/obstools/healthcheck-endpoint)](LICENSE.txt)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

Simple configurable application healthcheck rack middleware. This middleware allows you to embed healthcheck endpoints into your rack based application to perform healthcheck probes. Make your application compatible with [Docker](https://docs.docker.com/reference/dockerfile/#healthcheck)/[Kubernetes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-liveness-http-request) healthchecks in a seconds.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuring](#configuring)
- [Usage](#usage)
  - [Integration](#integration)
    - [Rack](#rack)
    - [Roda](#roda)
    - [Hanami](#hanami)
    - [Rails](#rails)
  - [Healthcheck endpoint response](#healthcheck-endpoint-response)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Credits](#credits)
- [Versioning](#versioning)
- [Changelog](CHANGELOG.md)

## Features

- Built-in default configuration
- Configurable services for startup/liveness/readiness probes
- Configurable root endpoints namespace
- Configurable startup/liveness/readiness probes endpoints
- Configurable successful/failure response statuses

## Requirements

Ruby MRI 2.5.0+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'healthcheck_endpoint'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install healthcheck_endpoint
```

## Configuring

To start working with this gem, you must configure it first as in the example below:

```ruby
# config/initializers/healthcheck_endpoint.rb

require 'healthcheck_endpoint'

HealthcheckEndpoint.configure do |config|
  # Optional parameter. The list of services that can be triggered
  # during running probes. Each value of this hash should be callable
  # and return boolean.
  # It is equal to empty hash by default.
  config.services = {
    postgres: -> { true },
    redis: -> { true },
    rabbit: -> { false }
  }

  # Optional parameter. The list of services that will be checked
  # during running startup probe. As array items must be used an
  # existing keys, defined in config.services.
  # It is equal to empty array by default.
  config.services_startup = %i[postgres]

  # Optional parameter. The list of services that will be checked
  # during running liveness probe. As array items must be used an
  # existing keys, defined in config.services.
  # It is equal to empty array by default.
  config.services_liveness = %i[redis]

  # Optional parameter. The list of services that will be checked
  # during running liveness probe. As array items must be used an
  # existing keys, defined in config.services.
  # It is equal to empty array by default.
  config.services_readiness = %i[postgres redis rabbit]

  # Optional parameter. The name of middleware's root
  # endpoints namespace. Use '/' if you want to use root
  # namespace. It is equal to /healthcheck by default.
  config.endpoints_namespace = '/application-healthcheck'

  # Optional parameter. The startup endpoint path.
  # It is equal to /startup by default.
  config.endpoint_startup = '/startup-probe'

  # Optional parameter. The liveness endpoint path.
  # It is equal to /liveness by default.
  config.endpoint_liveness = '/liveness-probe'

  # Optional parameter. The readiness endpoint path.
  # It is equal to /readiness by default.
  config.endpoint_readiness = '/readiness-probe'

  # Optional parameter. The HTTP successful status
  # for startup probe. It is equal to 200 by default.
  config.endpoint_startup_status_success = 201

  # Optional parameter. The HTTP successful status
  # for liveness probe. It is equal to 200 by default.
  config.endpoint_liveness_status_success = 202
  
  # Optional parameter. The HTTP successful status
  # for readiness probe. It is equal to 200 by default.
  config.endpoint_readiness_status_success = 203

  # Optional parameter. The HTTP failure status
  # for startup probe. It is equal to 500 by default.
  config.endpoint_startup_status_failure = 501

  # Optional parameter. The HTTP failure status
  # for liveness probe. It is equal to 500 by default.
  config.endpoint_liveness_status_failure = 502

  # Optional parameter. The HTTP failure status
  # for readiness probe. It is equal to 500 by default.
  config.endpoint_readiness_status_failure = 503
end
```

## Usage

### Integration

Please note, to start using this middleware you should configure `HealthcheckEndpoint` before and then you should to add `HealthcheckEndpoint::RackMiddleware` on the top of middlewares list.

#### Rack

```ruby
require 'healthcheck_endpoint'

# Configuring HealthcheckEndpoint with default settings
HealthcheckEndpoint.configure

Rack::Builder.app do
  use HealthcheckEndpoint::RackMiddleware
  run YourApplication
end
```

#### Roda

```ruby
require 'healthcheck_endpoint'

# Configuring HealthcheckEndpoint with default settings
HealthcheckEndpoint.configure

class YourApplication < Roda
  use HealthcheckEndpoint::RackMiddleware
end
```

#### Hanami

```ruby
# config/initializers/healthcheck_endpoint.rb

require 'healthcheck_endpoint'

# Configuring HealthcheckEndpoint with default settings
HealthcheckEndpoint.configure
```

```ruby
# config/environment.rb

Hanami.configure do
  middleware.use HealthcheckEndpoint::RackMiddleware
end
```

#### Rails

For Rails 7+, you can use the built-in healthcheck feature provided by Rails itself. See the [official Rails documentation on healthchecks](https://edgeapi.rubyonrails.org/classes/Rails/HealthController.html) for details. However, if you need more advanced healthcheck functionality or want to maintain consistency across different frameworks, you can still use this gem with Rails as follows:

```ruby
# config/initializers/healthcheck_endpoint.rb

require 'healthcheck_endpoint'

# Configuring HealthcheckEndpoint with default settings
HealthcheckEndpoint.configure
```

```ruby
# config/application.rb

class Application < Rails::Application
  config.middleware.use HealthcheckEndpoint::RackMiddleware
end
```

### Healthcheck endpoint response

Each healthcheck endpoint returns proper HTTP status and body. Determining the response status is based on the general result of service checks (when all are successful the status is successful, at least one failure - the status is failure). The response body represented as JSON document with a structure like in the example below:

```json
{
  "data": {
    "id": "a09efd18-e09f-4207-9a43-b4bf89f76b47",
    "type": "application-startup-healthcheck",
    "attributes": {
        "postgres": true,
        "redis": true,
        "rabbit": true
    }
  }
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/obstools/healthcheck-endpoint>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct. Please check the [open tickets](https://github.com/obstools/healthcheck-endpoint/issues). Be sure to follow Contributor Code of Conduct below and our [Contributing Guidelines](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `healthcheck_endpoint` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Credits

- [The Contributors](https://github.com/obstools/healthcheck-endpoint/graphs/contributors) for code and awesome suggestions
- [The Stargazers](https://github.com/obstools/healthcheck-endpoint/stargazers) for showing their support

## Versioning

`healthcheck_endpoint` uses [Semantic Versioning 2.0.0](https://semver.org)
