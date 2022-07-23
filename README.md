# Portholes

Portholes is a replacement for Instapaper or Pocket. The main differences are article sorting and a better parser.

## Article Parsing

[Mozilla's Readability library](https://github.com/mozilla/readability) is the main parser. You can see the call in [/lib/portholes/parser.rb](https://github.com/bradonomics/portholes-sinatra/blob/master/lib/portholes/parser.rb). Should Mozilla's Readability library fail, I've written a basic parser as a fall back.

## Ebook Creation

Portholes uses Calibre's `ebook-convert` to create ebook files as seen in [/lib/portholes/ebook.rb](https://github.com/bradonomics/portholes-sinatra/blob/master/lib/portholes/ebook.rb). You will need to install [Calibre](https://calibre-ebook.com/) locally before Portholes will work.

## Screenshots

Folder view:

![](https://github.com/bradonomics/portholes-sinatra/blob/master/screenshots/folder.png)

Single article view:

![](https://github.com/bradonomics/portholes-sinatra/blob/master/screenshots/article-single.png)

## Usage

First, clone or download this repo. Next, in your terminal type `bundle install` to install gems from the [Gemfile](https://github.com/bradonomics/portholes-sinatra/blob/master/Gemfile). To start the program type `bundle exec thin start` to run the server.

### Bookmarklet

To create a bookmarklet in your bookmarks for saving articles, you will need to create a new bookmark, edit that bookmark, and then add the below as the URL.

```
javascript:void%20function(){script=document.createElement(%22script%22),script.src=%22http://localhost:3000/article%22,document.head.appendChild(script)}();
```

### Ebook Format

The ebook format is hardcoded to `azw3`. If you wish to change this you will need to edit the `ebook` method in [/lib/portholes/ebook.rb](https://github.com/bradonomics/portholes-sinatra/blob/master/lib/portholes/ebook.rb). The `ebook-convert` docs can be found on the [Calibre website](https://manual.calibre-ebook.com/generated/en/ebook-convert.html).

## License

Use of Portholes is governed by the GNU AGPLv3 license that can be found in the [LICENSE](https://github.com/bradonomics/portholes-sinatra/blob/master/LICENSE) file.
