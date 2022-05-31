require 'fileutils'
require 'uri'
require 'nokogiri'
require 'down'
require 'http'
require 'rack/mime'

module Portholes
  class Ebook
    attr_reader :ebook_file_name

    def initialize(articles, folder)
      @articles = articles
      @full_directory_path = "public/downloads/#{DateTime.now.to_s.parameterize}"
      @folder = folder
      @ebook_file_name = "Portholes-#{folder.name.parameterize(preserve_case: true)}-#{Date.today.to_s}"
      download
      ebook(@full_directory_path, @ebook_file_name, @folder)
    end

    private

      def download
        Dir.mkdir("public/downloads") unless Dir.exists?("public/downloads")
        FileUtils.rm_rf("public/downloads/.", secure: true) # Remove previously downloaded files
        Dir.mkdir(@full_directory_path) unless Dir.exists?(@full_directory_path)
        files = []

        @articles.order(:position).first(50).each do |url|
          article = url.body

          # Get article hostname (domain name)
          host = URI.parse(url.source_url).host

          # Add title and file_name to files array
          title = url.title
          file_name = url.id
          files.push([title, file_name])

          # Download images and replace image src in article
          Dir.mkdir("#{@full_directory_path}/#{file_name}") unless Dir.exists?("#{@full_directory_path}/#{file_name}")
          article = images(@full_directory_path, file_name, article)

          # Create a new file in `directory` with article contents
          writer("#{@full_directory_path}/#{file_name}.html", article, title, host)

          # Create table of contents
          table_of_contents("#{@full_directory_path}/toc.html", files)
        end

      end

      def images(full_directory_path, file_name, document)

        # Tell nokogiri this is not a whole document
        article = Nokogiri::HTML::DocumentFragment.parse(document)

        count = 1
        # Replace the src for downloaded images
        article.css('img').each do |img|
          # If the image source is `nil` or an empty string, check if there is a `data-src` et al
          if img.attr('src').blank?
            if img.attr('data-src').present?
              img.set_attribute('src', img.attr('data-src'))
            elsif img.attr('data-image').present?
              img.set_attribute('src', img.attr('data-image'))
            elsif img.attr('data-img').present?
              img.set_attribute('src', img.attr('data-img'))
            else
              img.set_attribute('src', '')
              no_image_found(full_directory_path, file_name, img, count)
              count += 1
              next
            end
          end

          # Make sure the image isn't an svg added as `data:image`
          # TODO: convert to image file?
          if img.attr('src').include? 'data:image/svg+xml'
            no_image_found(full_directory_path, file_name, img, count)
            count += 1
            next
          end

          # Set `url` from `src`
          url = URI.parse(img.attr('src'))

          # Check if there is some amazon ad nonsense
          if url.host.include?('amazon-adsystem.com')
            img.set_attribute('src', '')
            no_image_found(full_directory_path, file_name, img, count)
            count += 1
            next
          end

          # Download the image with Down gem
          if HTTP.get(url).code == 200 # Check that the image is avaliable (no 404s)
            image = Down.download(img.attr('src'))
            # Get the file extention
            image_type = Rack::Mime::MIME_TYPES.invert[image.content_type]
            # Rename the file for those idiots who like to string URLs together and break the internet
            image_name = "#{to_words(count)}" + "#{image_type}"
            # Move the file to the appropriate directory
            FileUtils.mv(image.path, "#{full_directory_path}/#{file_name}/#{image_name}")
            # Update the `img` tag in the article body
            img.attributes['src'].value = "#{file_name}/#{image_name}"
          else
            no_image_found(full_directory_path, file_name, img, count)
          end

          count += 1
        end

        return article

      end

      def no_image_found(full_directory_path, file_name, img, count)
        # Copy the "no-image" file to the appropriate directory
        FileUtils.cp("app/assets/no-image.jpg", "#{full_directory_path}/#{file_name}/#{to_words(count)}.jpg")
        # Update the `img` tag in the article body
        img.attributes['src'].value = "#{file_name}/#{to_words(count)}.jpg"
      end

      def writer(target_file, article, title, host)
        File.open(target_file, 'w') do |outfile|
          outfile.puts "<html><head><title>#{title}</title></head>"
          outfile.puts "<body><h2>#{title}</h2><p>#{host}</p><hr>"
          outfile.puts article
          outfile.puts "</body></html>"
        end
      end

      def table_of_contents(target_file, files)
        date = Date.today
        title = date.strftime("#{date.day} %B %Y")

        File.open(target_file, 'w') do |outfile|
          outfile.puts "<html><head><title>Portholes: #{title}</title></head><body><h1>Portholes</h1><h2>#{title}</h2>"
          outfile.puts "<ul>"
          for file in files
            outfile.puts "<li><a href=\"#{file[1]}.html\">#{file[0]}</a></li>"
          end
          outfile.puts "</ul>"
          outfile.puts "</body></html>"
        end

      end

      def ebook(full_directory_path, ebook_file_name, folder)
        date = Date.today
        system("zip -r #{full_directory_path}.zip #{full_directory_path}")
        system("ebook-convert #{full_directory_path}.zip public/downloads/#{ebook_file_name}.epub --authors \"Portholes\" --chapter 'page' --title \"#{folder.name}: #{date.strftime('%a, %d %b %Y')}\" --change-justification 'left' --page-breaks-before '/'")
        system("ebook-convert public/downloads/#{ebook_file_name}.epub public/downloads/#{ebook_file_name}.azw3")
        File.delete("#{full_directory_path}.zip")
        File.delete("public/downloads/#{ebook_file_name}.epub")
        FileUtils.rm_r(full_directory_path)
      end

      def to_words(integer)
        numbers_to_name = {
            100 => "hundred",
            90 => "ninety",
            80 => "eighty",
            70 => "seventy",
            60 => "sixty",
            50 => "fifty",
            40 => "forty",
            30 => "thirty",
            20 => "twenty",
            19 => "nineteen",
            18 => "eighteen",
            17 => "seventeen",
            16 => "sixteen",
            15 => "fifteen",
            14 => "fourteen",
            13 => "thirteen",
            12 => "twelve",
            11 => "eleven",
            10 => "ten",
            9 => "nine",
            8 => "eight",
            7 => "seven",
            6 => "six",
            5 => "five",
            4 => "four",
            3 => "three",
            2 => "two",
            1 => "one"
          }
        str = ""
        numbers_to_name.each do |number, name|
          if integer == 0
            return 'zero'
          elsif integer.to_s.length == 1 && integer/number > 0
            return str + "#{name}"
          elsif integer < 100 && integer/number > 0
            return str + "#{name}" if integer%number == 0
            return str + "#{name} " + to_words(integer%number)
          elsif integer/number > 0
            return str + to_words(integer/number) + " #{name} " + to_words(integer%number)
          end
        end
      end

  end
end
