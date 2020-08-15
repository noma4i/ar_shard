require 'test_helper'

class ShardRecordOne
  connected_shards shards: [
    { deep_shard_1: { adapter: 'sqlite3', database: 'deep_shard_1' } },
    { deep_shard_2: { adapter: 'sqlite3', database: 'deep_shard_2' } }
  ]
end

class ShardRecordTwo
  connected_shards shards: [
    { deep_shard_3: { adapter: 'sqlite3', database: 'deep_shard_3' } },
    { deep_shard_4: { adapter: 'sqlite3', database: 'deep_shard_4' } }
  ]
end

class ARShardDeepTest < ShardTesting
  DBS = %w[deep_shard_1 deep_shard_2 deep_shard_3 deep_shard_4].freeze

  def setup
    prepar_chunk(dbs: DBS)
  end

  def teardown
    teardown_list(dbs: DBS)
  end

  def test_sharding
    ShardRecordOne.with_shard(:deep_shard_1) do
      assert_equal 'deep_shard_1', ShardOne::User.last.name

      ShardRecordTwo.with_shard(:deep_shard_3) do
        assert_equal 'deep_shard_3', ShardTwo::User.last.name
      end

      assert_equal 'main', User.last.name
    end
  end
end
