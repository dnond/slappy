module Slappy
  class Messanger
    class MissingChannelException < StandardError; end

    CHANNEL_APIS = [SlackAPI::Channel, SlackAPI::Group, SlackAPI::Direct]

    def initialize(options)
      @destination = {}
      @destination = options[:channel]
      options.delete :channel
      @options = options
    end

    def message
      options = merge_params(@options)

      if @destination.is_a? SlackAPI::Base
        id = @destination.id
      else
        instance = nil
        CHANNEL_APIS.each do |klass|
          instance = klass.find(name: @destination) || klass.find(id: @destination)
          break unless instance.nil?
        end
        fail MissingChannelException.new, "channel / #{@destination} is not found" if instance.nil?
        id = instance.id
      end

      options[:channel] = id
      Slack.chat_postMessage options
    end

    private

    def config
      Slappy.configuration
    end

    def merge_params(options)
      default = config.send_params
      default.merge options
    end
  end
end
