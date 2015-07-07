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
          client = sensu_clients.select { |c| c[:address] == ip }.shift
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


    private

      def sensu_clients limit=1000, offset=0, results=[]
        loop do
          endpoint = '/clients?limit=%d&offset=%d' % [ limit, offset ]
          request  = Net::HTTP::Get.new endpoint
          response = http.request request
          clients  = JSON.parse response.body, symbolize_names: true

          return results if clients.empty?
          results += clients
          offset  += limit
        end
      end

    end
  end
end