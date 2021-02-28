
# Required libraries
require 'uri'
require 'open-uri'
require 'rexml/document'

load 'extensions.rb'

# Operation class
class Operator
  RSS = 'rss'
  CSV = 'csv'

  # Initialize class
  def initialize(input:)
    # Parse input info
    @input = if input =~ /\A#{URI::regexp(['http', 'https'])}\z/ && open(input).status == ["200", "OK"]
               @source = RSS
               # Get RSS content
               open(input, &:read)
             elsif File.file?(input)
               @source = CSV
               # Get file content
               File.read(input)
             else
               nil
             end
  end

  # Execute operations
  def execute(operations:)
    # Ignore if no operations provided
    return if operations.blank?

    # Parse operations
    operations.each do |operation|
      # If argument presents
      if operation.include? '('
        arguments = operation.split('(').last.split(')').first
        arguments = arguments.split('/').reject { |c| c.blank? } unless arguments.nil?

        # Call operation
        self.send(operation.split('(').first, arguments)
      else
        # Call operation
        self.send(operation)
      end
    end
  end

  # Return result
  def result
    @input
  end

  private

  # Cut operation handler
  def cut
    # Ignore if no valid input provided
    return if @input.nil?

    case @source
    when RSS
      # Load document
      doc = REXML::Document.new(@input)
      # Find elements and trim content
      REXML::XPath.each(doc,'//title | //description') { |e| e.text = e.text.truncate(10) }
      # Save modified input
      @input = doc.to_s
    # when CSV
      # Outside of scope (Not properly specified on requirement document)
    else
      # Ignore
    end
  end

  # Replace operation handler
  def replace(opt)
    # Ignore if no valid input provided
    return if @input.nil? || opt.blank?

    case @source
    when RSS
      # Load document
      doc = REXML::Document.new(@input)
      # Find elements and trim content
      REXML::XPath.each(doc,"//*[contains(text(),'#{opt[0]}')]") { |e| e.text = e.text.gsub(opt[0], opt[1]) }
      # Save modified input
      @input = doc.to_s
    when CSV
      @input.gsub!(opt[0], opt[1])
    else
      # Ignore
    end
  end
end