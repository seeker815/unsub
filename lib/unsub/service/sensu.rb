module Unsub
  module Service
    class Sensu < Base
      attr_reader :http

      def initialize url, log
        uri   = URI.parse url
        @http = Net::HTTP.new uri.host, uri.port
        @log  = log
      end


      def extend_host host
        name = if ip = host[:ip]
          get_clients = Net::HTTP::Get.new '/clients?limit=1000000'
          response = http.request get_clients
          clients  = JSON.parse response.body, symbolize_names: true
          client   = clients.select { |c| c[:address] == ip }.shift
          client.nil? ? nil : client[:name]
        end

        old_host = host.dup ; host.merge! sensu_name: name if name
        log.info service: 'sensu', event: 'extend_host', old_host: old_host, host: host
        host
      end


      def delete_client host
        success = if name = host[:sensu_name]
          delete_client = Net::HTTP::Delete.new '/clients/%s' % name
          response = http.request delete_client
          response.kind_of? Net::HTTPSuccess
        end

        log.info service: 'sensu', event: 'delete_client', host: host, success: success
        success
      end
    end
  end
end