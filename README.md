# MongoidSeeder

Provides basic behavior to seed data while using Mongoid.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid_seeder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid_seeder

## Usage

Place an output of `mongodump` in `db/seed_data/`.  This will be used to seed your database.  *View the Custom Behavior section to learn how to override this path.*

### Rake Task

#### Rails

In rails, add this to `db/seeds.rb` to bootstrap the default seed rake tasks:

```ruby
require 'mongoid_seeder'

puts "Loading Seed Data"

if some_condition_to_decide_to_seed_or_not
  puts "Importing data at #{MongoidSeeder.db_path}\n"
  MongoidSeeder.seed
  puts "\nFinished.\n"
else
  puts "Data already exists, no need to seed."
end
```

#### Ruby

If you are not using rails, or would like more functionality with rake, add the following to `lib/tasks/db.rake`:

```ruby
namespace :db do
  desc 'Seed the database'
  task :seed => :prepare do
    puts "Loading Seed Data"

    if some_condition_to_decide_to_seed_or_not
      MongoidSeeder.seed
      puts "Importing data at #{MongoidSeeder.db_path}"
    else
      puts "Data already exists, no need to seed."
    end
  end

  desc 'Drops the database'
  task :drop => :prepare do
    MongoidSeeder.drop
  end

  desc 'Dumps the database to the seed location'
  task :dump => :prepare do
    MongoidSeeder.dump
    puts "Dumping data to #{MongoidSeeder.db_path}"
  end

  desc 'Drops db and seeds it'
  task :reseed => [:drop, :seed]

  task :prepare do
    require 'mongoid_seeder'
    # Do stuff to setup your app environment
  end
end
```

### Rspec

Use within your rspec tests like so:

```ruby
require 'mongoid_seeder'

RSpec.configure do |config|
  config.before(:suite) do
    MongoidSeeder.before_suite
  end

  config.before(:each) do
    MongoidSeeder.before_each
  end

  config.after(:each) do
    MongoidSeeder.after_each
  end

  config.after(:suite) do
    MongoidSeeder.after_suite
  end
end
```

### Cucumber

```ruby
require 'mongoid_seeder'

Before do
  MongoidSeeder.before_suite unless @cucumber_started # Only happen once
  @cucumber_started = true
  MongoidSeeder.before_each
end

After do
  MongoidSeeder.after_each
end

at_exit do
  MongoidSeeder.after_suite
end
```

## Default Behavior

By default these methods run the following:

Method | Default Behavior
---|---
`before_suite` | Seeds the database
`before_each` | no-op
`after_each` | no-op
`after_suite` | Drops the database

## Custom Behavior

### Bootstrapping the mongoid seeder

To bootstrap the seeder with custom configuration, place all configuration in a file located at `config/mongoid_seeder.rb`.  This file will be loaded when the seeder is ran if it exists.

### DB Path

You can configure the location where the seed data is stored by doing the following:

```ruby
require_relative '../config/environment'

MongoidSeeder::Config.seed_dir = "/path/to/my/seeds"
```

You may want to do this if you want to use different sets of seed data for different environments.

### Callback Methods

*The default behavior cannot be overridden, you can only prepend to the behavior*

This means that you can add additional steps to be ran for each method if you would like.

```
MongoidSeeder::Config.before_suite = -> do
  MyApp.load_env
end

# Must use old lambda syntax because of the argument
# This will drop all collections that includes "v2" in the collection name
# after each test is ran
MongoidSeeder::Config.condition_to_drop_collection = lambda do |a|
  a.name.include?('v2')
end
```

## Owners

Developed by [@coffeencoke](http://github.com/coffeencoke), [@dcameronmauch](http://github.com/dcameronmauch), devs on a team at [Asynchrony](http://asynchrony.com).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
