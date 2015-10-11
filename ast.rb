# utf 8

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
            Multiply.new(left.reduce(environment, right)
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

    def reduce
        if left.reducible?
            LessThan.new(left.reduce, right)
        elsif right.reducible?
            LessThan.new(left, right.reduce)
        else
            Boolean.new(left.value < right.value)
        end
    end
end


# Example expression to parse.
expression = Add.new(
    Multiply.new(Number.new(1), Number.new(2)),
    Multiply.new(Number.new(3), Number.new(4))
)
# => «1 * 2 + 3 * 4»
expression.reducible?
# => true
expression.reduce
# => «2 + 3 * 4»
expression.reduce.reducible?
# => true
expression.reduce.reduce
# => «2 + 12»
expression.reduce.reduce.reducible?
# => true
expression.reduce.reduce.reduce
# => «14»
expression.reduce.reduce.reduce.reducible?
# => false



class Machine < Struct.new(:expression)
    def step
        self.expression = expression.reduce
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
    )
).run
# 1 * 2 + 3 * 4
# 2 + 3 * 4
# 2 + 12
# 14
# => nil
