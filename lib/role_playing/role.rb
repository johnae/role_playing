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