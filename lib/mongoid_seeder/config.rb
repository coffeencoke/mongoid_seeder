module MongoidSeeder
  require 'mixlib/config'

  class Config
    extend Mixlib::Config

    before_suite -> { true } # no-op
    before_each -> { true } # no-op
    after_each -> { true } # no-op
    after_suite -> { true } # no-op
    condition_to_drop_collection lambda { |collection| false } # drop nothing
    config_file File.join(Dir.pwd, 'config', 'mongoid_seeder.rb') # app_root/config/mongoid_seeder.rb
    seed_dir File.join(Dir.pwd, 'db', 'seed_data') # app_root/db/seed_data
  end

  require Config.config_file if File.exists?(Config.config_file)
end
