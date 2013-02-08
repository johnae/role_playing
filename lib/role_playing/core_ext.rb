## PLEASE NOTE: This is almost completely unnecessary except for some syntax sugar which I like.
## It basically does this: TheRole.new(theObject) and returns it and also runs an instance_eval
## if a block was given. It can also take many Roles, not just one so you could do theObject.as(SomeRole, AnotherRole).
class Object
  def in_roles(*roles, &block)
    extended = roles.inject(self) { |extended, role| role.new(extended) }
    block_given? ? yield(extended) : extended
  end
  def in_role(role, &block)
    in_roles(*role, &block)
  end
end