require_relative './config/environment'

if ActiveRecord::Base.connection_pool.migration_context.needs_migration?
  raise 'Migrations are pending. Run `bundle exec rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use FoldersController
use ArticlesController
run ApplicationController
