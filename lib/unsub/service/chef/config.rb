#
# Cribbed from Ridley: https://github.com/reset/ridley/blob/master/lib/ridley/chef/config.rb
#
require 'buff/config/ruby'

module Unsub
  module Service
    class Chef < Base
      class Config < Buff::Config::Ruby
        class << self
          def location
            possibles = []
            possibles << ENV['CHEF_CONFIG'] if ENV['CHEF_CONFIG']
            possibles << File.join(ENV['KNIFE_HOME'], 'knife.rb') if ENV['KNIFE_HOME']
            possibles << File.join(Dir.pwd, 'knife.rb')
            possibles << File.join(ENV['HOME'], '.chef', 'knife.rb') if ENV['HOME']
            possibles.compact!

            location = possibles.find { |loc| File.exists?(File.expand_path(loc)) }
            File.expand_path(location) unless location.nil?
          end
        end

        set_assignment_mode :carefree

        attribute :node_name,
          default: -> { Socket.gethostname }
        attribute :chef_server_url,
          default: 'http://localhost:4000'
        attribute :client_key,
          default: -> { '/etc/chef/client.pem' }

        def initialize(path, options = {})
          super(path || self.class.location, options)
        end
      end
    end
  end
end