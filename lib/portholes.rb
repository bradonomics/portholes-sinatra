# Require all portholes files
Dir[File.join(__dir__, 'portholes', '*.rb')].each { |file| require file }

module Portholes
  extend self

  def initialize; end

  def new(url)
    Document.new(url)
  end

end
