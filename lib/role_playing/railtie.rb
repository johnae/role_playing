require 'rails'

module RolePlaying
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'role_playing.configure_rails_initialization' do |app|
      config.autoload_paths += %W(#{config.root}/app/contexts)
    end
  end
end