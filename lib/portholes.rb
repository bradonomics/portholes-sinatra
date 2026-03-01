# Require all portholes files
Dir[File.join(__dir__, 'portholes', '*.rb')].each { |file| require file }

module Portholes
  extend self

  def initialize; end

  def new(url, last_parser)
    Document.new(url, last_parser)
  end

end

if __FILE__ == $0
  # p = Portholes.new("https://bradonomics.com/abou/")
  p = Portholes.new("https://www.newyorker.com/culture/personal-history/notes-on-work", nil)
  # p = Portholes.new("https://bradonomics.com/about/?utm_source=hackernewsletter&utm_medium=email&utm_term=fav&fbclid=8", nil)
  # p = Portholes.new("https://medialyte.xyz/rising-price-newsprint-threatens-industry/")
  # p = Portholes.new("https://ellegriffin.substack.com/p/kevin-maguire-is-anti-work-goals")
  # p = Portholes.new("https://www.schneier.com/blog/archives/2022/02/a-new-cybersecurity-social-contract.html")
  # p = Portholes.new("https://www.deepsouthventures.com/how-on-earth/")
  # p = Portholes.new("https://medium.com/@farsi_mehdi/error-handling-in-ruby-part-ii-f26c6a575c68")
  puts "p.url => #{p.url}"
  puts "p.title => #{p.title}"
  # puts "p.author => #{p.author}"
  puts "p.body => #{p.body}"
  # puts "p.parser_used => #{p.parser_used}"
end
