
load 'classes/base.rb'

# Cut class inheriting from Base
class Cut < Base
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
end

