
load 'classes/cut.rb'

# Replace class inheriting from Cut
class Replace < Cut
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
