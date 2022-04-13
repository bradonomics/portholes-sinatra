# Require all portholes files
Dir[File.join(__dir__, 'portholes', '*.rb')].each { |file| require file }

module Portholes
  extend self

  def initialize; end

  def new(url, last_parser)
    Document.new(url, last_parser)
  end

end
