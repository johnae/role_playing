module RolePlaying
  module RspecRole
    def self.included(base)
      base.instance_eval do
        alias :role :context
      end
    end
  end
end

RSpec.configure do |config|
  config.include(RolePlaying::RspecRole)
end