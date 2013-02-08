module RolePlaying
  module Context
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def const_missing(sym)
        class_name = sym.to_s
      end
      def role(name, parent=nil, &block)
        parent = parent || RolePlaying::Role
        klass = Class.new(parent, &block)
        const_set name, klass
      end
    end
  end
end