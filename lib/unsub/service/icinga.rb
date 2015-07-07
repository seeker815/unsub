module Unsub
  module Service
    class Icinga < Base
      attr_reader :uri, :http

      def initialize cmd_url, log
        @uri  = URI.parse cmd_url
        @http = Net::HTTP.new uri.host, uri.port
        @log  = log
      end


      def disable_notifications host
        success = cgi_command 29, host # CMD_DISABLE_HOST_SVC_NOTIFICATIONS
        log.info service: 'icinga', event: 'disable_notifications', host: host, success: success
        success
      end


      def enable_notifications host
        success = cgi_command 28, host # CMD_ENABLE_HOST_SVC_NOTIFICATIONS
        log.info service: 'icinga', event: 'enable_notifications', host: host, success: success
        success
      end


    private

      def cgi_command command, host, opts={}
        params = {
          cmd_typ: command,
          cmd_mod: 2,
          host: (host[:sensu_name] || host[:chef_name]),
          btnSubmit: 'Commit'
        }.merge opts

        if name = params[:host]
          request  = Net::HTTP::Post.new uri.request_uri
          request.basic_auth uri.user, uri.password
          request.set_form_data params
          response = http.request request
          response.kind_of? Net::HTTPSuccess
        end
      end
    end
  end
end