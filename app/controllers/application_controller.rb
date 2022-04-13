require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'better_errors'
require 'uri'

class ApplicationController < Sinatra::Base

  register Sinatra::Reloader
  also_reload('lib/**/*.rb')
  register Sinatra::CrossOrigin
  register Sinatra::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    enable :cross_origin
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
  end

  get '/' do
    redirect_to_home_page
  end

  helpers do

    def inline_svg(path)
      file = File.open("public/images/#{path}", "rb")
      file.read.to_s
    end

    def redirect_to_home_page
      redirect to '/folder/unread'
    end

    def url_only(url)
      # TODO: Change this method name. It's confusing.
      URI.parse(url).host
    end

    def downloadable_folder?
      return true if request.path_info.include?('/folder') && request.path_info != '/folder/archive'
    end

    def article_page?
      return true if request.path_info.include?('/article')
    end

  end

end
