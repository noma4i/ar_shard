require 'active_record'

module ActiveRecord
  mattr_accessor :klass_name

  class Base
    mattr_accessor :isolated_connection

    def self.add_shared_override!
      shard_model.define_singleton_method(:connection) do
        @@isolated_connection || retrieve_connection
      end
    end
  end

  module ConnectionHandling
    mattr_accessor :connection_handlers, instance_accessor: false, default: {}

    def connected_shards(shards: nil)
      @connected_shards ||= begin
        config_data = parse_config(shards)
        @@klass_name = self.name
        connections = {}

        shard_model.add_shared_override!

        config_data.each do |shard|
          key, conf = shard.flatten
          handler = lookup_connect(key.to_sym)

          connections[key.to_sym] = handler.establish_connection(conf)
        end

        connections
      end
    end

    def parse_config(config)
      return config.call if config.is_a?(Proc)
      return config if config.is_a?(Array)

      raise ARShard::Error.new 'Shard config should be Array or Proc'
    end

    def shard_model
      @shard_model ||= @@klass_name.constantize
    end

    def lookup_connect(handler_key)
      if defined?(connection_handlers)
        connection_handlers[handler_key] ||= ActiveRecord::ConnectionAdapters::ConnectionHandler.new
      else
        @@connection_handlers[handler_key] ||= ActiveRecord::ConnectionAdapters::ConnectionHandler.new
      end
    end

    def with_shard(handler_key, &blk)
      shard_model.isolated_connection = connected_shards[handler_key].connection
      return_value = yield
      return_value.load if return_value.is_a? ActiveRecord::Relation
      return_value
    ensure
      shard_model.isolated_connection = nil
    end
  end
end

