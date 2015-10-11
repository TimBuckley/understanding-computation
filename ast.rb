#!/bin/env ruby
# encoding: utf-8

class Variable < Struct.new(:name)
    def to_s
        name.to_s
    end

    def inspect
        "«#{self}»"
    end

    def reducible?
        true
    end

    def reduce(environment)
        environment[name]
    end
end


class Number < Struct.new(:value)
    def to_s
        value.to_s
    end

    def inspect
        "«#{self}»"
    end

    def reducible?
        false
    end

    def reduce
        puts('No longer reducible')
        self
    end
end

class Add < Struct.new(:left, :right)
    def to_s
        "#{left} + #{right}"
    end

    def inspect
        "«#{self}»"
    end

    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            Add.new(left.reduce(environment), right)
        elsif right.reducible?
            Add.new(left, right.reduce(environment))
        else
            Number.new(left.value + right.value)
        end
    end
end

class Multiply < Struct.new(:left, :right)
    def to_s
        "#{left} + #{right}"
    end

    def inspect
        "«#{self}»"
    end

    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            Multiply.new(left.reduce(environment), right)
        elsif right.reducible?
            Multiply.new(left, right.reduce(environment))
        else
            Number.new(left.value * right.value)
        end
    end
end


class Boolean < Struct.new(:value)
    def to_s
        value.to_us
    end

    def inspect
        "«#{self}»"
    end

    def reducible?
        false
    end
end


class LessThan < Struct.new(:left, :right)
    def to_s
        "«#{left} < #{right}»"
    end

    def inspect
        "«#{self}»"
    end

    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            LessThan.new(left.reduce(environment), right)
        elsif right.reducible?
            LessThan.new(left, right.reduce(environment))
        else
            Boolean.new(left.value < right.value)
        end
    end
end


class GreaterThan < Struct.new(:left, :right)
    def to_s
        "«#{left} > #{right}»"
    end

    def inspect
        "«#{self}»"
    end

    def reducible?
        true
    end

    def reduce(environment)
        if left.reducible?
            GreaterThan.new(left.reduce(environment), right)
        elsif right.reducible?
            GreaterThan.new(left, right.reduce(environment))
        else
            Boolean.new(left.value > right.value)
        end
    end
end


# # Example expression to parse.
# env = {}
# expression = Add.new(
#     Multiply.new(Number.new(1), Number.new(2)),
#     Multiply.new(Number.new(3), Number.new(4))
# )
# # => «1 * 2 + 3 * 4»
# expression.reducible?
# # => true
# expression.reduce(env)
# # => «2 + 3 * 4»
# expression.reduce(env).reducible?
# # => true
# expression.reduce(env).reduce(env)
# # => «2 + 12»
# expression.reduce(env).reduce(env).reducible?
# # => true
# expression.reduce(env).reduce(env).reduce(env)
# # => «14»
# expression.reduce(env).reduce(env).reduce(env).reducible?
# # => false



class Machine < Struct.new(:expression, :environment)
    def step
        self.expression = expression.reduce(environment)
    end

    def run
        while expression.reducible?
            puts expression
            step
        end

        puts expression
    end
end

# Example use of Machine to parse expression.
Machine.new(
    Add.new(
        Multiply.new(Number.new(1), Number.new(2)),
        Multiply.new(Number.new(3), Number.new(4))
    ), {}
).run
# 1 * 2 + 3 * 4
# 2 + 3 * 4
# 2 + 12
# 14
# => nil

Machine.new(
    Add.new(Variable.new(:x), Variable.new(:y)),
    { x: Number.new(3), y: Number.new(4) }
).run

class DoNothing
    def to_s
        'do-nothing'
    end

    def inspect
        "«#{self}»"
    end

    def ==(other_statement)
        other_statement.instance_of?(DoNothing)
    end

    def reducible?
        false
    end
end
