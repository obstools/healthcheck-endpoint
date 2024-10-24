# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-10-25

### Updated

- Updated gem name to `healthcheck_endpoint`, namespace to `HealthcheckEndpoint`
- Updated gem runtime/development dependencies
- Updated gem documentation

## [0.3.0] - 2024-04-15

### Added

- Added ability to show in the response current probe type

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

## [0.2.0] - 2024-03-28

### Added

- Added ability to use configuration with default settings without block passing

```ruby
HealthcheckEndpoint.configure # It will create configuration instance with default settings
```

### Updated

- Updated `HealthcheckEndpoint.configure`, tests
- Updated gem documentation

## [0.1.0] - 2024-03-26

### Added

- First release of `healthcheck_endpoint`.
