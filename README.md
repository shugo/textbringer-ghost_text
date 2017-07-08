# textbringer-ghost_text

[![Gem Version](https://badge.fury.io/rb/textbringer-ghost_text.svg)](https://badge.fury.io/rb/textbringer-ghost_text)

[GhostText](https://github.com/GhostText/GhostText) plugin for [Textbringer](https://github.com/shugo/textbringer).

## Installation

    $ gem install textbringer-ghost_text

## Configuration

```ruby
# The host of the GhostText server.
CONFIG[:ghost_text_host] = "127.0.0.1"
# The port of the GhostText server.
CONFIG[:ghost_text_port] = 4001
```

## Usage

Type `M-x ghost_text_start` to start the server.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shugo/textbringer-ghost_text.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
