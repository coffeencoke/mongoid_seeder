require 'mongoid-shell'
require 'mongoid'
require 'fileutils'

require_relative 'mongoid_seeder/config'

module MongoidSeeder
  def self.before_suite
    Config.before_suite.call
    seed
  end

  def self.before_each
    Config.before_each.call
  end

  def self.after_each
    Config.after_each.call
    after_tests
  end

  def self.after_suite
    Config.after_suite.call
    drop
  end

  def self.seed
    options = {
      db: Mongoid.session(:default).options[:database],
      restore: db_path
    }
    mongorestore = Mongoid::Shell::Commands::Mongorestore.new(options)
    system mongorestore.to_s
  end

  def self.db_path
    File.expand_path("db/seed_data", Dir.pwd)
  end

  def self.dump
    mongodump = Mongoid::Shell::Commands::Mongodump.new( out: db_path)
    system mongodump.to_s
  end

  def self.drop
    Mongoid.session(:default).drop
  end

  def self.after_tests
    Mongoid.session(:default).collections.select{|a| Config.condition_to_drop_collection.call(a) }.each(&:drop)
  end
end
