require 'test_helper'

class ClusterRecord
  connected_shards shards: [
    { shard_1: { adapter: 'sqlite3', database: 'shard_1' } },
    { shard_2: { adapter: 'sqlite3', database: 'shard_2' } },
    { shard_3: { adapter: 'sqlite3', database: 'shard_3' } }
  ]
end

class ARShardTest < ShardTesting
  def test_main_db
    assert_equal 'main', User.last.name
  end

  def test_sharding
    ClusterRecord.with_shard(:shard_1) do
      assert_equal 'shard_1', Shard::User.last.name
      assert_equal 'main', User.last.name
    end

    ClusterRecord.with_shard(:shard_2) do
      assert_equal 'shard_2', Shard::User.last.name
      assert_equal 'main', User.last.name
    end

    assert_equal 'main', Shard::User.last.name
  end
end
