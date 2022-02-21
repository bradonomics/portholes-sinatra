class FoldersController < ApplicationController

  # displays a all folders
  get '/folders' do
    @folders = Folder.all
    erb :'folders/folders'
  end

  # displays a single folder
  get '/folder/:permalink' do
    @folder = Folder.find_by(permalink: params[:permalink])
    @articles = Article.all
    erb :'folders/show_folder'
  end

end
