class ArticlesController < ApplicationController
  set :show_exceptions, :after_handler

  # new article page
  get '/article/new' do
    @folders = Folder.all
    erb :'articles/new_article'
  end

  # new article from bookmarklet
  get '/article' do
    content_type 'text/javascript'
    erb :'articles/index_article.js', layout: false
  end

  # create new article
  post '/article' do
    cross_origin
    if is_number?(params[:source_url])
      article = Article.new
      article.title = params[:title]
      article.source_url = params[:source_url]
      article.body = params[:body]
      article.folder_id = params[:folder_id]
      article.position = Article.count + 1
    else
      document = Portholes.new(params[:source_url])
      # if link is already in database for this user, move it to home
      if Article.find_by_source_url(document.url).present?
        article = Article.find_by_source_url(document.url)
        # Move the article in position 0 so this article can be in position 0
        first_article_in_folder = Article.left_outer_joins(:folder).where(folder: { id: params[:folder_id] }, position: 0)
        first_article_in_folder.update(position: 1)
        article.position = 0
        article.folder_id = params[:folder_id]
      else
        article = Article.new
        article.title = document.title
        article.source_url = document.url
        article.body = document.body
        article.folder_id = params[:folder_id]
        article.position = Article.count + 1
      end
    end
    article.save!
    folder = Folder.find(article.folder_id)
    redirect to("/folder/#{folder.permalink}")
  rescue StandardError => error
    flash[:error] = error.message
    folder = Folder.find(params[:folder_id])
    redirect to("/folder/#{folder.permalink}")
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

  helpers do
    def is_number?(string)
      string.scan(/\D/).empty?
    end
  end

end
