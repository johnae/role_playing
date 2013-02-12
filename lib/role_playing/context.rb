module RolePlaying
  module Context
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      ## this seemed to dangerous to use
      ## it enabled us to use Constants when
      ## defining roles but would also not
      ## warn about missing constants - which is pretty bad
      #def const_missing(sym)
      #  sym
      #end
      def role(name, parent=nil, &block)
        parent = parent || RolePlaying::Role
        klass = Class.new(parent, &block)
        define_method(name) do |*args, &role_block|
          instance = klass.new(*args)
          role_block.nil? ? instance : role_block.call(instance)
        end
        const_set name, klass
      end
    end
  end
end