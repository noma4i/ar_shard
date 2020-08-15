require 'test_helper'

class DynClusterRecord
  connected_shards shards: -> { YAML.load_file('test/support/shards.yml') }
end

class ARShardDynamicTest < ShardTesting
  DBS = %w[dyn_shard_1 dyn_shard_2].freeze

  def setup
    prepar_chunk(dbs: DBS)
  end

  def teardown
    teardown_list(dbs: DBS)
  end

  def test_dyn_sharding
    DynClusterRecord.with_shard(:dyn_shard_1) do
      assert_equal 'dyn_shard_1', DynShard::User.last.name
      assert_equal 'main', User.last.name
    end

    DynClusterRecord.with_shard(:dyn_shard_2) do
      assert_equal 'dyn_shard_2', DynShard::User.last.name
      assert_equal 'main', User.last.name
    end

    assert_equal 'main', User.last.name
  end
end
