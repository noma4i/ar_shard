module Shard
end

module DynShard
end

class ClusterRecord < ActiveRecord::Base
  self.abstract_class = true
end

class DynClusterRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Shard::User < ClusterRecord
end

class DynShard::User < DynClusterRecord
end

class User < ActiveRecord::Base
end

class DynConfig < ActiveRecord::Base
end

class ShardTesting < Minitest::Test
  DBS = %w[shard_1 shard_2 shard_3 main].freeze

  def setup
    DBS.each do |db|
      File.delete(db) if File.exist?(db)

      ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db)

      ActiveRecord::Schema.define do
        create_table :users do |t|
          t.string :name
        end
      end

      User.create!(name: db)
    end

    ActiveRecord::Schema.define do
      create_table :dyn_configs do |t|
        t.string :name
        t.string :adapter, default: 'sqlite3'
        t.string :database
      end
    end

    DBS.each do |db|
      DynConfig.create(name: db, database: db)
    end
  end

  def teardown
    ActiveRecord::Base.clear_active_connections!
    DBS.each { |d| File.delete(d) }
  end
end
