[![Build Status](https://travis-ci.org/johnae/role_playing.png)](https://travis-ci.org/johnae/role_playing)

# RolePlaying

A ruby DCI implementation using SimpleDelegator. This was extracted from a Rails app I'm working on. It's a very simple and straightforward implementation.

I'm well aware that this is not "true" DCI but I believe it to be in the spirit of DCI while avoiding the awfulness that is object.extend.

Using object.extend in Ruby has two severe problems, one that makes it not true DCI and another that makes it really really slow:

1. There is no unextend
2. It blows rubys method cache when used

A further comment on 2 is that it means EVERY time you call extend it blows Rubys ENTIRE method cache - it doesn't mean just the object you're extending, it means everything.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'role_playing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install role_playing

## Usage

Using it is as simple as defining (usually) a context like so:

```ruby
class MoneyTransferring
  include RolePlaying::Context

  def initialize(from_account, to_account)
    @from_account = from_account
    @to_account = to_account
  end
  def call(amount)
    ## this is a little contrived I know
    ## it could be easily implemented using
    ## increment/decrement methods - just
    ## showing the block syntax here
    SourceAccount(@from_account) do |source_account|
      DestinationAccount(@to_account).deposit(source_account.withdraw(amount))
    end
  end

  role :SourceAccount do
    def withdraw(amount)
      self.amount=self.amount-amount
      amount
    end
  end

  role :DestinationAccount do
    def deposit(amount)
      self.amount=self.amount+amount
    end
  end

end
```

```ruby
class MyRole < RolePlaying::Role
  def my_additional_method
  end
end

class MyOtherRole < RolePlaying::Role
  def my_other_method
  end
end
```

And, if defined by themselves, they can be applied in a few ways:

```ruby
## our data object which will play different roles (eg. get new/different behavior within a context)
class MyDataObject
end

MyRole.played_by(MyDataObject) do |role|
  role.my_additional_method
end
```

or

```ruby
role = MyRole.played_by(MyDataObject)
role.my_additional_method
```

several roles can be applied too like so:

```ruby
[MyRole, MyOtherRole].played_by(MyDataObject) do |role|
  role.my_additional_method
  role.my_other_method
end
```

or

```ruby
role = [MyRole, MyOtherRole].played_by(MyDataObject)
role.my_additional_method
role.my_other_method
```

Within a context a role is defined by the role class method. The syntax sugar of applying a role - eg. MyRole(MyDataObject) do |role| - is only available within classes including the RolePlaying::Context module. This was the way I envisioned it - to basically keep all code concerning a context within the same file (and inside the context class).

Please read the specs for a better understanding. Also please look up DCI (data, context, interaction) for a better understanding of what this is trying to accomplish.

## RSpec

Theres an RSpec extension included which basically aliases RSpecs context to role so the language used in RSpec can be closer to DCI when testing these things.
To use that extension just do require 'role_playing/rspec_role' in your spec_helper. Look at the specs in this gem to see what I mean.

## Rails

Theres a Railtie that adds autoloading of directory "contexts", the idea is to put all contexts and roles in there (roles are defined within the surrounding
context in the same file).

The structure would look like:

    app/
        assets/
    ->  contexts/
        controllers/
        helpers/
        models/
        ...


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
