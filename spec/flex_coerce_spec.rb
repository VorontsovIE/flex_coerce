$:.unshift '../lib/'
require 'flex_coerce'
require 'rspec/given'

class UnitNoOptionalArgument
  attr_reader :num
  def initialize(num)  @num = num;  end
  def coerce(other) [other, self.num];  end
end

class UnitBothRequired
  attr_reader :num
  def initialize(num)  @num = num;  end
  def coerce(other, meth)  [other, self.num];  end
end

class UnitWeakCheck
  attr_reader :num
  def initialize(num)  @num = num;  end
  def coerce(other, meth = nil)  [other, self.num];  end
end

class UnitStrongCheck
  attr_reader :num
  def initialize(num)  @num = num;  end
  
  def coerce(other, meth = nil)
    raise TypeError 'Coercing error'  unless meth
    case meth.to_sym
    when :*, :/
      [other, self.num]
    when :+, :-
      raise TypeError, 'Coercing error'
    end
  end
end



describe FlexCoerce do
  context 'with #coerce having the only required and no optional arguments' do
    Given(:unit_class) { UnitNoOptionalArgument }
    Given(:number){ 3 }
    Given(:unit) { unit_class.new(2) }
    context 'before prepending FlexCoerce' do
      When(:plus_operation) { number + unit }
      Then{plus_operation.should == 5}
      When(:mul_operation) { number * unit }
      Then{mul_operation.should == 6}
    end
    context 'after prepending FlexCoerce' do
      When{ unit_class.send :prepend, FlexCoerce }
      
      When(:plus_operation) { number + unit }
      Then{plus_operation.should == 5}
      When(:mul_operation) { number * unit }
      Then{mul_operation.should == 6}
    end
  end
  
  context 'with #coerce having the only required and no optional arguments' do
    context 'with coerce not checking method' do
      Given(:unit_class) { UnitWeakCheck }
      Given(:number){ 3 }
      Given(:unit) { unit_class.new(2) }
      context 'before prepending FlexCoerce' do
        When(:plus_operation) { number + unit }
        Then{plus_operation.should == 5}
        When(:mul_operation) { number * unit }
        Then{mul_operation.should == 6}
      end
      context 'after prepending FlexCoerce' do
        When { unit_class.send :prepend, FlexCoerce }
        
        When(:plus_operation) { number + unit }
        Then{plus_operation.should == 5}
        When(:mul_operation) { number * unit }
        Then{mul_operation.should == 6}
      end
    end
    
    context 'with coerce checking method' do
      Given(:unit_class) { UnitStrongCheck }
      Given(:number){ 3 }
      Given(:unit) { unit_class.new(2) }
      context 'before prepending FlexCoerce' do
        When(:plus_operation) { number + unit }
        Then{plus_operation.should have_failed}
        When(:mul_operation) { number * unit }
        Then{mul_operation.should have_failed}
      end
      context 'after prepending FlexCoerce' do
        When { unit_class.send :prepend, FlexCoerce }
        
        When(:plus_operation) { number + unit }
        Then{plus_operation.should have_failed}
        When(:mul_operation) { number * unit }
        Then{mul_operation.should == 6}
      end
    end
  end

  context 'with #coerce having two required arguments' do
    Given(:unit_class) { UnitBothRequired }
    Given(:number){ 3 }
    Given(:unit) { unit_class.new(2) }
    context 'before prepending FlexCoerce' do
      When(:plus_operation) { number + unit }
      Then{plus_operation.should have_failed}
      When(:mul_operation) { number * unit }
      Then{mul_operation.should have_failed}
    end
    context 'after prepending FlexCoerce' do
      When { unit_class.send :prepend, FlexCoerce }
      
      When(:plus_operation) { number + unit }
      Then{plus_operation.should == 5}
      When(:mul_operation) { number * unit }
      Then{mul_operation.should == 6}
    end
  end  

end