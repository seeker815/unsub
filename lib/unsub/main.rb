require 'net/http'
require 'json'
require 'uri'

require 'daybreak'
require 'aws-sdk'

require_relative 'mjolnir'
require_relative 'metadata'
require_relative 'service'
require_relative 'event'


Celluloid.logger = nil
Thread.abort_on_exception = false



module Unsub
  class Main < Mjolnir

    default_command :go

    KNIFE = [
      File.join(ENV['HOME'], '.chef', 'knife.rb'),
      File.join('/etc', 'chef', 'knife.rb'),
      ENV['KNIFE']
    ].select { |f| f && File.exists?(f) }.shift


    desc 'version', 'Show the application version'
    def version
      puts VERSION
    end


    desc 'art', 'Show the application art'
    def art
      puts "\n%s\n" % ART
    end


    desc 'go', 'Start the main event loop'
    option :database, \
      type: :string,
      aliases: %w[ -d ],
      desc: 'Local database path',
      default: '.ops1722.db'
    option :queue_url, \
      type: :string,
      aliases: %w[ -q ],
      desc: 'SQS Queue URL',
      required: true
    option :icinga_cmd, \
      type: :string,
      aliases: %w[ -c ],
      desc: 'Icinga Command URI',
      required: true
    option :sensu_url, \
      type: :string,
      aliases: %w[ -s ],
      desc: 'Sensu API base URL',
      required: true
    option :knife_file, \
      type: :string,
      aliases: %w[ -k ],
      desc: 'Knife file for Chef',
      default: KNIFE,
      required: true
    include_common_options
    def go
      db = Daybreak::DB.new options.database

      aws = {
        ec2: Aws::EC2::Client.new,
        sqs: Aws::SQS::Client.new
      }

      services = {
        icinga: Service::Icinga.new(options.icinga_cmd, log),
        sensu: Service::Sensu.new(options.sensu_url, log),
        chef: Service::Chef.new(options.knife_file, log)
      }

      log.info service: 'main', event: 'hello', \
        db: db, aws: aws, services: services

      loop do
        response = aws[:sqs].receive_message queue_url: options.queue_url

        response.messages.each do |raw|
          receipt = raw.receipt_handle
          body    = JSON.parse raw.body
          message = JSON.parse body['Message']
          event   = Event.new message, db, aws, services

          success = case event.kind
          when :launch
            s1 = services[:icinga].disable_downtime event.host
            s2 = services[:chef].remove_tag event.host, 'terminated'
            s3 = services[:chef].add_tag event.host, 'launched'
            s1 && s2 && s3
          when :terminate
            s1 = services[:sensu].delete_client event.host
            s2 = services[:icinga].enable_downtime event.host
            s3 = services[:chef].remove_tag event.host, 'launched'
            s4 = services[:chef].add_tag event.host, 'terminated'
            db.delete! event.host[:id]
            s1 && s2 && s3 && s4
          end

          aws[:sqs].delete_message \
            queue_url: options.queue_url,
            receipt_handle: receipt

          log.info service: 'main', event: 'processed', \
            message: message, receipt: receipt, success: success
        end
      end
    end

  end
end