class ArticlesController < ApplicationController
  set :show_exceptions, :after_handler

  # new article page
  get '/article/new' do
    @folders = Folder.all
    erb :'articles/new_article'
  end

  # display an article
  get '/article/:id' do
    @article = Article.find(params[:id])
    erb :'articles/show_article'
  end

  # edit article page
  get '/article/:id/edit' do
    @article = Article.find(params[:id])
    @folders = Folder.all
    @this_folder = @article.folder.id
    erb :'articles/edit_article'
  end

  # update existing article
  patch '/article/:id' do
    article = Article.find(params[:id])
    article.update(title: params[:title], link: params[:link], body: params[:body], folder_id: params[:folder_id])
    redirect to("/article/#{article.id}")
  end

  # delete article
  delete '/article/:id/delete' do
    article = Article.find(params[:id])
    folder = Folder.find(article.folder_id)
    article.destroy
    redirect to("/folder/#{folder.permalink}")
  end

  # archive article
  patch '/article/:id/archive' do
    article = Article.find(params[:id])
    folder = Folder.find(article.folder_id)
    article.folder_id = Folder.find_by(name: "Archive").id
    article.save!
    redirect to("/folder/#{folder.permalink}")
  end

  # unarchive article
  patch '/article/:id/unarchive' do
    article = Article.find(params[:id])
    folder = Folder.find(article.folder_id)
    Article.left_outer_joins(:folder).where(folder: { name: "Unread" }, position: 0).update(position: 1)
    article.position = 0
    article.folder_id = Folder.find_by(name: "Unread").id
    article.save!
    redirect to("/folder/#{folder.permalink}")
  end

end
