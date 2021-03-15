
# Required libraries
require 'uri'
require 'open-uri'
require 'rexml/document'

load 'extensions.rb'

# Base class
class Base
  RSS = 'rss'
  CSV = 'csv'

  # Initialize class
  def initialize(input:)
    # Parse input info
    @source = parse input
    # Get input data
    @input = case @source
             when RSS
               # Get RSS content
               open(input, &:read)
             else
               # Get file content
               File.read(input)
             end
  end

  private

  # Parse input source
  def parse(input)
    if input =~ /\A#{URI::regexp(['http', 'https'])}\z/ && open(input).status == ["200", "OK"]
      RSS
    elsif File.file?(input)
      CSV
    else
      nil
    end
  end
end