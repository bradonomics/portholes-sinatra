require 'sinatra/base'
require 'sinatra/reloader'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  register Sinatra::Reloader
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
  end

  get '/' do
    redirect to '/folders'
  end

  helpers do

    def inline_svg(path)
      file = File.open("app/public/images/#{path}", "rb")
      raw file.read
    end

  #   def redirect_to_home_page
  #     redirect to "/expenses"
  #   end

  #   def redirect_to_categories
  #     redirect to "/categories"
  #   end

  end

end
