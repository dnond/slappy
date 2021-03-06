# Slappy

[![Gem Version](https://badge.fury.io/rb/slappy.svg)](https://badge.fury.io/rb/slappy)
[![Build Status](https://travis-ci.org/wakaba260/slappy.svg?branch=master)](https://travis-ci.org/wakaba260/slappy)
[![Code Climate](https://codeclimate.com/github/wakaba260/slappy/badges/gpa.svg)](https://codeclimate.com/github/wakaba260/slappy)
[![Test Coverage](https://codeclimate.com/github/wakaba260/slappy/badges/coverage.svg)](https://codeclimate.com/github/wakaba260/slappy/coverage)
[![Dependency Status](https://gemnasium.com/wakaba260/slappy.svg)](https://gemnasium.com/wakaba260/slappy)

This gem support to make slack bot, inspire from [hubot](https://github.com/github/hubot) and [sinatra](https://github.com/sinatra/sinatra).

Use the Slack Realtime API and Web API(see the [official-documentation](https://api.slack.com)).

## Quick Start

### 1. Generate Slack API Token

Slack API Token generate from [official page](https://api.slack.com/web).

### 2. Set environment variable to Slack API Token

Slappy references `ENV['SLACK_TOKEN']` default.

### 3. Run generator

Execute then command to generate project:


    $ slappy new project-name


If you want to use current directory, execute then command:

    $ slappy new

(If you use bundler, add `bundle exec` prefix)

### 4. Write code

Create ruby file to under `project-name/slappy-scripts`, and written code.

Example:

```ruby
# catch pattern
hear '^hello, slappy!' do |event|
  logger.info 'received message!'
  say 'hello!!', channel: event.channel #=> respond message to channel
end
```

There scripts not share scopes with other scripts.

### 5. Slappy start

Execute then command in project root directory.

    $ slappy start

(Stop: Input Ctrl+c)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slappy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slappy

## Usage
### ENV
Store configuration value in environment variables. They are easy to change between deploys without changing any code.

```
SLACK_TOKEN - required (when not configured)
```

### Configure
Configure default settings.
There configrations effect on send message to slack when use `say` method and should override when option given.

#### Example

```ruby
require 'slappy'

Slappy.configure do |config|
  config.token = 'foobar'
  config.robot.username   = 'slappy'
  config.robot.channel    = '#general'
  config.robot.icon_emoji = ':slappy:'
end

Slappy.say 'hello!' #=> username: slappy, channel: '#general', icon_emoji: ':slappy:'
```

#### Configuration Parameters

```
token            - default: ENV['SLACK_TOKEN']
scripts_dir_path - default : 'slappy-scripts'

robot.botname    - not effect now
robot.username   - default: 'slappy'
robot.icon_emoji - default: nil
robot.channel    - default: '#general'
robot.icon_url   - default: nil
robot.as_user    - default: false
```

### Basic Usage

```ruby
# called when start up
hello do
  logger.info 'successfly connected'
end
```

#### Send and Receive Message

```ruby
# called when match message
hear 'foo' do
  logger.info 'foo'
end

# use regexp in string literal
hear 'bar (.*)' do |event|
  logger.info event.matches[1] #=> Event#matches return MatchData object
end

# event object is slack event JSON (convert to Hashie::Mash)
hear '^bar (.*)' do |event|
  say 'slappy!', channel: event.channel  #=> to received channel object
  say 'slappy!', channel: '#general'     #=> send to public channel
  say 'slappy!', channel: 'private-room' #=> send to private group
  say 'slappy!', username: 'slappy!', icon_emoji: ':slappy:' #=> change config
end

# use regexp literal
hear(/^foobar/) do
  logger.info 'slappppy!'
end
```

#### Monitoring Types Event

```ruby
monitor 'channel_joined' do |event|
  say "Welcome to #{event.name}!", channel: event.channel
end

monitor 'team_join' do |event|
  say "Welcome to this team!", channel: "#general"
end
```

#### Schedule Event

```ruby
schedule '* * * * *' do
  logger.info 'Slappy alive...' #=> Repeat every minutes.
end
```

#### Sleep Event

There conditions, this event be called:

- `raise StandardError` in script
- trap SIGTERM or SIGINT

```
goodnight do
  logger.info 'goodnight'
end
```

### DSL Methods

|method|when execute callback|
|:---:|:---|
|hello|start up|
|hear|message (match pattern)|
|monitor|[Slack RTM event](https://api.slack.com/rtm)|
|schedule|specify time ([Syntax is here](https://github.com/r7kamura/chrono)) - Thanks to Chrono!|

### In your Application

If you not want execute `slappy start` command, written by (require `'slappy/dsl'` use DSL):

```
require 'slappy'

Slappy.hello do
  # In your code..
end

Slappy.say 'message to slack'

Slappy.start #=> Start WebSocket connection
```

## Release Note

- v0.5.2
  - Add debug logging
  - Fix schedule id is not normality

- v0.5.1
  - Fix monitor event disabled

- v0.5.0
  - Support Schedule
  - Support Slack RMT Event
  - Support private group
  - Support as_user option
  - Introduce SlackAPI objects
    - Group
    - Channel
    - Direct
    - User

- v0.4.0
  - Support logger
  - Support load lib directory
  - Add New command
    - version
  - Choise dsl enabled in slappy_config

- v0.3.0
  - Introduce DSL
  - Introduce CLI commands
    - start
    - new
  - Use String literal for hear parameter
  - Chose dsl use in slappy_config

- v0.2.0
  - Modify interface

- v0.1.0
  - Release

## Feature

- [ ] Execute in shell (because testable).
- [ ] Support private channel
- [ ] Support Schedule event (cron like)
- [ ] Add bot name
- [ ] client#respond (hubot#respond like)
- [ ] Split chat adapter

## Contributing

1. Fork it ( http://github.com/wakaba260/slappy/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

