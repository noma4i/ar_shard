# AR Shard

AR Shard is non-intrusive extenstion for ActiveRecord to add threadsafe Model based sharding or just multidatabase connection. As this gem uses connection_handlers it can work only with ActiveRecord 6 and above.

## Features
- Shard only part of you ActiveRecord w/o sharing connection
- Work with you Sharded Model and AR model at the same time
- Threadsafe. Battle-tested with Sidekiq and 4 mixed Databases
- Define config as a Proc. `Due to nature of connection_handlers all DB connections are established at boot time`


## Installation

Add this line to your application’s Gemfile:

```ruby
gem 'ar_shard', '~> 0.2'
```

## Usage

Define your separate AR like:

```ruby
class ShardRecord < ActiveRecord::Base
  self.abstract_class = true

  connected_shards shards: [
    { shard_1: { adapter: 'sqlite3', database: 'shard_1' } },
    { shard_2: { adapter: 'postgresql', database: 'shard_2' } },
    { shard_3: { adapter: 'sqlite3', database: 'shard_3' } }
  ]
end
```

or with Proc

```ruby
class ShardRecord < ActiveRecord::Base
  self.abstract_class = true

  connected_shards shards: -> { YAML.load_file('path/to/config/shards.yml') }
end
```

given we have models like:

```ruby
class User < ActiveRecord::Base

end

class Sharded::User < ShardRecord

end
```

AR Shard is isolating and rotating connections. Same like Rails Multibase support but without overlap.
Now we can do crazy things like:

```ruby
# Connecting to another DB
ShardRecord.with_shard(:shard_name) do
  Sharded::User.find_each do |user|
    # Working with our DB and another at the same time!

    u = User.find_by(email: user.email)
    u.update(name: user.name)
  end
end
```

## Contributing

- [Report bugs](https://github.com/noma4i/ar_shard/issues)
- Fix bugs and [submit pull requests](https://github.com/noma4i/ar_shard/pulls)

To get started with development:

```sh
git clone https://github.com/noma4i/ar_shard.git
cd ar_shard
bundle install
bundle exec rake test
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
