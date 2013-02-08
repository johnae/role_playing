module RolePlaying
  module Context
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def role(name, parent=nil, &block)
        parent = parent || RolePlaying::Role
        klass = Class.new(parent, &block)
        self.const_set name.to_s.camelize, klass
      end
    end
  end
end