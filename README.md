# Hashstructor

There comes a time in every wee programmer's life (and all programmers are, for the purposes of this readme, wee or previously wee) when one must take a big blob of JSON or YAML and make it into an object. Or worse, a hierarchy of objects. This leads to lots of very manual parsing and gnashing of teeth. Some libraries, like the mildly spiffy [constructor](https://github.com/atomicobject/constructor), allow you to defray some of this pain by letting you pass in hashes to build objects, but this only goes so far: no type coercion, no nested types.

Finally I got tired of this mess when building a game prototype and writing enough stupid read-in code of data files that I decided to Fix This Situation. (You can argue that I got sidetracked; I won't disagree.) After about three hours of late-night work, I'm somewhat proud to unveil **Hashstructor**: your one-stop shop for mangling the heck out of Ruby hashes and building neat-o object trees out of them. You can also turn them back into hashes with `#to_hash`--I've found this really useful for transient domain objects in message queues. The creator can create objects with validation and structure and then `#to_hash` them when they go into the queue, and the same can be done when you get them back out.

Hashstructor is _fully documented_ (100% coverage in `yard`) and comes with a fairly exhaustive set of tests to prove that it actually does what it's supposed to do.

## Installation ##

Add this line to your application's Gemfile:

```ruby
gem 'hashstructor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hashstructor

## Usage ##

Hashstructor is pretty easy to deal with, but it's 2:10AM as I write this and I am very tired, so I shall direct you to the [fancy and/or schmancy](https://github.com/eropple/hashstructor/tree/master/spec) `spec` folder. In `test_classes` you will find examples of nearly every aspect of Hashstructor, and `hashstructor_spec.rb` explains them with a little context.

YARD documentation is hosted at http://eropple.github.io/hashstructor .

Hashstructor is designed for Ruby 2.0 and above, but _may_ run on Ruby 1.9.x; failure to do so is not a bug.

## Development ##

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing ##

Bug reports and pull requests are welcome on GitHub at https://github.com/eropple/hashstructor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License ##

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

