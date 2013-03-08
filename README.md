# FlexCoerce

FlexCoerce - is a gem which allow you create operator-dependent coercion logic. It's useful when your type should be treated in a different way for different binary operations (including arithmetic operators, bitwise operators and comparison operators except equality checks: `==`, `===`).

## Installation

Attention: this gem works only with Ruby 2.0 because it uses Module#prepend which has no analogs in Ruby 1.9. If you have an idea how to realize it on 1.9 without too much mess - your pull-requests are welcome.

Add this line to your application's Gemfile:

    gem 'flex_coerce'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flex_coerce

## Usage

I'll show you an example of (very simplistic) class Unit for physical units. We can multiply numbers with units but can't add them.

```
require 'flex_coerce'
class Unit
  attr_reader :num, :unit
  def initialize(num, unit)
    @num, @unit = num, unit
  end
  def +(other)
    raise TypeError, 'Can\'t add Unit to a non-Unit'  unless other.is_a? Unit
    raise ArgumentError, 'Can\'t sum units of different types'  unless other.unit == unit
    Unit.new(num + other.num, unit)
  end
  def *(other)
    return self * Unit.new(other, '1')  if other.is_a? Numeric
    Unit.new(num * other.num, "#{unit}*#{other.unit}")
  end
  def coerce(other, meth = nil)
    raise TypeError, 'Coercion error: can\'t coerce non-numeric class to a Unit'  unless other.is_a? Numeric
    case meth.to_sym
    when :*
      [Unit.new(other,'1'), self]
    when :+
      raise TypeError 'Coercion error: can\'t compare Unit to a non-unit anything'
      [other, self]
    else
      raise TypeError, 'Unsupported operation'
    end
  end
  
  prepend FlexCoerce
end

5 * Unit.new(3,'cm') #  ==>  Unit(15,'1*cm')
5 + Unit.new(3,'cm') #  ==>  raises an Error
```

All the magic is in `prepend FlexCoerce` call. It decorates your coerce method with another one, which follow ruby conventions about coerce method. This is done by creating an instance of `CoerceableWrapper` class which takes a reference to left-side object. This intermediate class defines its own methods for binary operators such that they play well with `#coerce` method of right-side object class. I should mention that this method works good for missing, optional or required second argument of `#coerce`, you can find examples in specs.

Possibly this example is too simplistic and can be made in another and more consistent way. But this is a proof of concept that coerce can be made method-specific without touching base ruby classes. You're welcome with more interesting examples and more powerful and clear design.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
