require_relative './config/environment'
require 'sinatra/activerecord/rake'
require 'csv'

task :c do
  Pry.start
end

task :import do
  puts "Import task is working."
  CSV.foreach('portholes-export-2022-06-02.csv', headers: true) do |row|
    article = Article.new
    article.source_url = row[0]
    article.title = row[1]
    article.body = row[2]
    article.folder_id = row[3]
    article.created_at = row[4]
    article.save
  end
  puts "After CSV call."
end

task :folders do |folder|
  Folder.create(name: "Unread")
  Folder.create(name: "Archive")
  Folder.create(name: "Dyslexia")
  Folder.create(name: "Dyslexia Archive")
  Folder.create(name: "Health Care")
  Folder.create(name: "Story Club")
  Folder.create(name: "Global Training Report")
end
