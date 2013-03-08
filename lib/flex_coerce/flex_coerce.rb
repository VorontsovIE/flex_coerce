module FlexCoerce
  def self.prepend_features(base)
    base.instance_eval{
      @__original_coerce_arity ||= base.instance_method(:coerce).arity
    }
    super
  end
  def coerce(other, meth = nil)
    if meth
      case self.class.class_eval{ @__original_coerce_arity }
      when 1
        super(other.obj)
      when 2, -2
        # coerce(other, meth) or coerce(other, meth = nil)
        super(other.obj, meth)
      else
        raise 'Too many arguments for coerce'
      end
    else
      [CoerceableWrapper.new(other), self]
    end
  end
end

# This class is a wrapper for object which redefines methods leading to coercion
class CoerceableWrapper
  attr_reader :obj
  def initialize(obj)
    @obj = obj
  end
  [:+, :-, :*,  :/, :%, :div, :divmod, :fdiv, :**,    :&, :|, :^,    :>,  :>=,  :<,  :<=,  :<=>].each do |op|
    define_method(op) do |other|
      self_coerced, other_coerced = other.coerce(self, op)
      self_coerced.send(op, other_coerced)
    end
  end
end 