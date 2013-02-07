require 'delegate'

module RolePlaying
  class Role < SimpleDelegator
    def class
      role_player.class ## this makes self.class return the extended objects class instead of DCIRole - should make the extension completely transparent
    end

    ## return the FINAL wrapped object
    def role_player
      player = self
      while player.respond_to?(:__getobj__)
        player = player.__getobj__
      end
      player
    end

  end
end

## PLEASE NOTE: This is almost completely unnecessary except for some syntax sugar which I like.
## It basically does this: TheRole.new(theObject) and returns it and also runs an instance_eval
## if a block was given. It can also take many Roles, not just one so you could do theObject.as(SomeRole, AnotherRole).
class Object
  def in_roles(*roles, &block)
    extended = roles.inject(self) { |extended, role| role.new(extended) }
    extended.instance_eval(&block) if block_given?
    extended
  end
  def in_role(role, &block)
    in_roles(*role, &block)
  end
end