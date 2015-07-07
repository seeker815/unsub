require 'chef-api'

require_relative 'chef/config'


module Unsub
  module Service
    class Chef < Base
      attr_reader :knife, :api

      def initialize knife, log
        @log   = log
        @knife = Config.new knife
        @api   = ChefAPI::Connection.new \
          endpoint: @knife.chef_server_url,
          client: @knife.node_name,
          key: @knife.client_key
      end


      def extend_host host
        name = if ip = host[:ip]
          api.search.query(:node, 'ipaddress:"%s"' % ip).rows.shift.name rescue nil
        end

        old_host = host.dup ; host.merge! chef_name: name if name
        log.info service: 'chef', event: 'extend_host', old_host: old_host, host: host
        host
      end


      def add_tag host, tag
        success = if name = host[:chef_name]
          node = api.nodes.fetch name
          node.normal['tags'] ||= []
          node.normal['tags'] << tag
          node.normal['tags'].uniq!
          !!node.save
        end

        log.info service: 'chef', event: 'add_tag', host: host, tag: tag, success: success
        success
      end


      def remove_tag host, tag
        success = if name = host[:chef_name]
          node = api.nodes.fetch name
          node.normal['tags'] ||= []
          node.normal['tags'].delete tag
          !!node.save
        end

        log.info service: 'chef', event: 'remove_tag', host: host, tag: tag, success: success
        success
      end
    end
  end
end