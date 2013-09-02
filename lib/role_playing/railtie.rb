require 'rails/railtie'

module RolePlaying
  class Railtie < Rails::Railtie #:nodoc:
    
    config.after_initialize do |app|
      ## this seems necessary
      Dir["#{config.root}/app/contexts/*"].each do |ctx|
         require_dependency ctx
      end
    end
    
  end
end