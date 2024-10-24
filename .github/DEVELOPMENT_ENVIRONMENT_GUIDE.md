# Development environment guide

## Preparing

Clone `healthcheck-endpoint` repository:

```bash
git clone https://github.com/obstools/healthcheck-endpoint.git
cd  ruby-gem
```

Configure latest Ruby environment:

```bash
echo 'ruby-3.2.0' > .ruby-version
cp .circleci/gemspec_latest healthcheck_endpoint.gemspec
```

## Commiting

Commit your changes excluding `.ruby-version`, `healthcheck_endpoint.gemspec`

```bash
git add . ':!.ruby-version' ':!healthcheck_endpoint.gemspec'
git commit -m 'Your new awesome healthcheck_endpoint feature'
```
