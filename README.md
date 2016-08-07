# Domparser

##Beta version

A simple dom parser, which can take the raw html file as input. All the information there in the html file will be translated automatically and all data will be stored in a tree structure. It can transform the html, it is also capable of simple search according to the attributes. The data structure is also reversible using the built-in rebuild function.

For example, for the very simple html code below

```html
<div>
  div text before
  <p>
    p text
  </p>
  <div>
    more div text
  </div>
  div text after
</div>
```

After using the gem, you will get a new data strcuture similar to the below.

```ruby
<struct Node tag="DOCUMENT", offset=nil, type="general", depth=0, attributes={},
children=[<struct Node tag="<div>", offset=0, type=:div, depth=2, attributes={},
  children=[<struct Node tag="div text before", offset=nil ......
    ....
    ....
```

## Installation

```ruby
gem 'domparser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install domparser

## Usage





## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lby89757/domparser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
