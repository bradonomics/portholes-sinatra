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
    redirect_to_home_page
  end

  helpers do

    def inline_svg(path)
      file = File.open("public/images/#{path}", "rb")
      file.read.to_s
    end

  #   def redirect_to_home_page
  #     redirect to "/expenses"
  #   end

    def redirect_to_home_page
      redirect to '/folder/unread'
    end

  end

end
