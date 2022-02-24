class FoldersController < ApplicationController

  before do
    @folders = Folder.all
  end

  # create a new folder
  post '/folder' do
    folder = Folder.find_by(name: params[:name])
    if folder.nil?
      folder = Folder.create(name: params[:name])
      flash[:message] = "Folder #{folder.name} created."
    else
      flash[:error] = "Folder #{params[:name]} already exists."
    end
    redirect to("/folder/#{folder.permalink}")
  end

  # display a folder
  get '/folder/:permalink' do
    @folder = Folder.find_by(permalink: params[:permalink])
    @articles = @folder.articles
    erb :'folders/show_folder'

  end

  # edit a folder
  get '/folder/:permalink/edit' do
    @folder = Folder.find_by(permalink: params[:permalink])
    erb :'folders/edit_folder'
  end

  # update existing folder
  patch '/folder/:permalink' do
    folder = Folder.find_by(permalink: params[:permalink])
    new_name = Folder.find_by(name: params[:name])
    if new_name.nil?
      folder.update(name: params[:name])
      flash[:message] = "Folder #{folder.name} changed."
      redirect to("/folder/#{folder.permalink}")
    else
      flash[:error] = "Folder #{params[:name]} already exists."
      redirect to("/folder/#{new_name.permalink}")
    end
  end

  # delete folder
  delete '/folder/:permalink/delete' do
    folder = Folder.find_by(permalink: params[:permalink])
    archive_folder = Folder.find_by(name: 'Archive')
    articles_in_folder = Article.where(folder: folder)

    unless articles_in_folder.empty?
      articles_in_folder.map do |article|
        Article.find(article.id).update_columns(folder_id: archive_folder.id)
      end
    end

    folder.delete
    flash[:message] = "#{folder.name} was deleted."
    redirect_to_home_page
  end

  helpers do

    def downloadable_folder?
      return true if request.path_info.include?('/folder') && request.path_info != '/folder/archive'
    end

    def default_folder?
      return true if request.path_info == '/folder/unread' || request.path_info == '/folder/archive'
    end

  end

end
