require 'bundler'
Bundler.require

# Root path of app
APP_ROOT = File.expand_path('.')

# Require Models
Dir.glob(File.join(APP_ROOT, 'app', 'models', '*.rb')).each { |file| require file }

# Require the Application Controller first
require File.join(APP_ROOT, 'app', 'controllers', 'application_controller.rb')
# Require other controllers
Dir.glob(File.join(APP_ROOT, 'app', 'controllers', '*.rb')).each { |file| require file }

# Require Portholes
require File.join(APP_ROOT, 'lib', 'portholes.rb')

# Database Configuration
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/portholes.db'
)
