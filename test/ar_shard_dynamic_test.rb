require "test_helper"

class DynClusterRecord
  connected_shards shards: -> { YAML.load_file('test/support/shards.yml') }
end
class ARShardDynamicTest < ShardTesting
  def test_sharding
    ClusterRecord.with_shard(:shard_1) do
      assert_equal 'shard_1', DynShard::User.last.name
      assert_equal 'main', User.last.name
    end

    ClusterRecord.with_shard(:shard_2) do
      assert_equal 'shard_2', DynShard::User.last.name
      assert_equal 'main', User.last.name
    end

    assert_equal 'main', DynShard::User.last.name
  end
end
