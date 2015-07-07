require 'ridley'

module Unsub
  module Service
    class Chef < Base
      attr_reader :ridley

      def initialize knife, log
        @ridley = Ridley.from_chef_config knife
        @log    = log
      end


      def extend_host host
        name = if ip = host[:ip]
          ridley.search(:node, 'ipaddress:"%s"' % ip).shift.name rescue nil
        end

        old_host = host.dup ; host.merge! chef_name: name if name
        log.info service: 'chef', event: 'extend_host', old_host: old_host, host: host
        host
      end


      def add_tag host, tag
        success = if name = host[:chef_name]
          node = ridley.node.find name
          node.reload
          node.normal.tags ||= []
          node.normal.tags << tag
          node.normal.tags.uniq!
          !!node.save
        end

        log.info service: 'chef', event: 'add_tag', host: host, tag: tag, success: success
        success
      end


      def remove_tag host, tag
        success = if name = host[:chef_name]
          node = ridley.node.find name
          node.reload
          node.normal.tags ||= []
          node.normal.tags.delete tag
          !!node.save
        end

        log.info service: 'chef', event: 'remove_tag', host: host, tag: tag, success: success
        success
      end
    end
  end
end