# RolePlaying

A ruby DCI implementation using SimpleDelegator. This was extracted from a Rails app I'm working on. It's a very simple and straightforward implementation.

I'm well aware that this is not "true" DCI but I believe it to be in the spirit of DCI while avoiding the awfulness that is object.extend.

Using object.extend in Ruby has two severe problems, one that makes it not true DCI and another that makes it really really slow:

1. There is no unextend
2. It blows rubys method cache when used

A further comment on 2 is that it means EVERY time you call extend it blows Rubys ENTIRE method cache - it doesn't mean just the object you're extending, it means everything.

## Installation

Add this line to your application's Gemfile:

    gem 'role_playing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install role_playing

## Usage

Using it is as simple as defining (usually) a context like so:

    class MyUseCase
      def initialize(something, something_else)
        @something = something
        @something_else = something_else
      end

      def call(an_arg)
        @something_else.in_role(Role2).special_method @something.in_role(Role1).additional_method
      end

      class Role1 < RolePlaying::Role
        def additional_method
          1
        end
      end

      class Role2 < RolePlaying::Role
        def special_method(value)
          puts value
        end
      end
    end

Please read the specs for a better understanding. Also please look up DCI (data, context, interaction) for a better understanding of what this is trying to accomplish.

## Rspec

Theres an Rspec extension included which basically aliases Rspecs context to role so the language used in Rspec can be closer to DCI when testing these things.
To use that extension just do require 'role_playing/rspec_role' in your spec_helper. Look at the specs in this gem to see what I mean.

## Links

http://dci-in-ruby.info

http://www.clean-ruby.com

http://tonyarcieri.com/dci-in-ruby-is-completely-broken - on why extend is bad

http://rubysource.com/dci-the-evolution-of-the-object-oriented-paradigm/

http://vimeo.com/8235394 - the inventor himself talks about DCI


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
