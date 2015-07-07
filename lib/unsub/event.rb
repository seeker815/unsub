module Unsub
  class Event
    attr_reader :kind, :host

    def initialize message, db, aws, services
      discover_kind message
      discover_host message, db, aws, services
    end


  private

    def discover_kind message
      @kind = case message['Event']
      when 'autoscaling:EC2_INSTANCE_LAUNCH'
        :launch
      when 'autoscaling:EC2_INSTANCE_TERMINATE'
        :terminate
      when 'autoscaling:EC2_INSTANCE_LAUNCH_ERROR'
        :launch_error
      when 'autoscaling:EC2_INSTANCE_TERMINATE_ERROR'
        :terminate_error
      end
    end


    def discover_host message, db, aws, services
      id = message['EC2InstanceId']

      @host = unless id.nil? || id.empty?
        is = aws[:ec2].describe_instances instance_ids: [ id ]
        ip = is.reservations.first.instances.first.private_ip_address

        host = { id: id, ip: ip }
        cached_host = db[id] || {}
        cached_host.each { |k,v| host[k] = v if host[k].nil? && v }
        services.each { |_, service| service.extend_host host }

        db.set! id, host
        host
      end
    end
  end
end