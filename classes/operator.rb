
load 'classes/replace.rb'

# Operation class inheriting from Replace
class Operator < Replace
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
end