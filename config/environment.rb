require 'bundler'
Bundler.require

# Root path of app
APP_ROOT = File.expand_path('..', __dir__)

# Require Models
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).each { |file| require file }

# Require Controllers
Dir.glob(File.join(APP_ROOT, 'app', 'controllers', '*.rb')).each { |file| require file }

# Require Portholes
require File.join(APP_ROOT, 'lib', 'portholes.rb')

# Database Configuration
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/portholes.db'
)
