# Undercover

Undercover is a tool for Ruby projects that will tell you two things about changes you make to code:

1. If a line of code that you added or changed is not covered by any tests.
2. If an existing line of code (that you _did not_ change) lost all coverage.

To do this, it relies on `git` (to know which files/lines you changed) and `simplecov` (to understand your test coverage). This of course
means that your project must use `git` for source control and be set up to generate `simplecov` reports (with the `simplecov-json`
formatter).

## Setting up SimpleCov

Follow the steps [here](https://github.com/colszowka/simplecov#getting-started) to get started with SimpleCov, and then
[here](https://github.com/vicentllongo/simplecov-json#usage) to install `simplecov-json` as your formatter. Keep in mind that SimpleCov can
support multiple formatters:

```ruby
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::RcovFormatter
]
```

It is **strongly recommended** that your coverage reports be all-or-nothing, i.e. you only generate coverage reports when you run the entire
test suite at once. (Otherwise Undercover will be left with partial data.) The simplest way to guarantee this is to enable coverage reports
only when an environment variable is present:

```ruby
# spec_helper.rb
SimpleCov.start if ENV["COVERAGE"]
```

This will allow you to control when you run coverage reports:

```bash
COVERAGE=true rake spec
```

While this approach works best in a CI/build environment, there is nothing stopping you from running coverage reports locally if you are
diligent. ;-)

## Setting up Undercover

Add `undercover` to your application's Gemfile in the `:test` group:

```ruby
gem 'undercover', group: :test
# Don't forget to run `bundle`
```

Then set up your `Rakefile` to run Undercover tasks as part of your `:default` rake task. For example:

```ruby
require 'rake/testtask'
require 'undercover/rake_task'

Rake::TestTask.new { |t| t.test_files = FileList['test/**/*_test.rb'] }
Undercover::RakeTask.new

task default: %i(test undercover)
```

Or with `rspec`:

```ruby
require 'rspec/core/rake_task'
require 'undercover/rake_task'

RSpec::Core::RakeTask.new('spec')
Undercover::RakeTask.new

task default: %i(spec undercover)
```

Now you can run your full suite and coverage reports in a single command:

```bash
COVERAGE=true rake
```

## Configuration

By default, Undercover assumes that your base branch is the `master` branch, and will automatically calculate changesets based on when you
diverged from `master`. This can be customized:

```ruby
Undercover.base_branches = %w(master stage)
```

When multiple branches are specified, Undercover will attempt to pinpoint which branch you diverged from most recently.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smudge/undercover.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
