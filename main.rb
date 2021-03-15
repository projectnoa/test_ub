
# Required libraries
require 'getoptlong'

load 'extensions.rb'
load 'classes/operator.rb'

# Argument keys accepted
HELP_KEY = '--help'
HELP_KEY_S = '-h'
INPUT_KEY = '--input'
INPUT_KEY_S = '-i'
CONVERT_KEY = '--convert'
CONVERT_KEY_S = '-c'
OUTPUT_KEY = '--output'
OUTPUT_KEY_S = '-o'

# Create argument options handler
opts = GetoptLong.new(
  [ HELP_KEY, HELP_KEY_S, GetoptLong::NO_ARGUMENT ],
  [ INPUT_KEY, INPUT_KEY_S, GetoptLong::REQUIRED_ARGUMENT ],
  [ CONVERT_KEY, CONVERT_KEY_S, GetoptLong::REQUIRED_ARGUMENT ],
  [ OUTPUT_KEY, OUTPUT_KEY_S, GetoptLong::OPTIONAL_ARGUMENT ]
)

# Initialize result
operator = nil

# Initialize argument variables
output = nil

if ARGV.any? { |s| s.include?(HELP_KEY) || s.include?(HELP_KEY_S) }
  # Provide help
  puts <<~EOF

    -h, --help:
         show help

    --input URL/PATH, -i URL/PATH:
         input url or path to process

    --input [URL/PATH], -i [URL/PATH]:
         input url or path to process

    --convert [cut/replace], -c [cut/replace]:
         operations to take
         cut: Trim each title and body if the length exceeds 10 characters.
         replace: Replace the specified words. e.g: from=uzabase, to=Uzabase, Inc.

    --output [PATH], -o [PATH]:
         path and file name to output the results to

  EOF

  return
else
  # Initialize operations array
  operations = []
  # Parse arguments passed
  opts.each do |opt, arg|
    # Ignore if empty or nil
    next if arg.blank?

    case opt
    when INPUT_KEY, INPUT_KEY_S
      # Parse input info
      operator = Operator.new(input: arg)
    when CONVERT_KEY, CONVERT_KEY_S
      # Parse operation info
      operations = arg.split(',').map { |i| i.strip }
    when OUTPUT_KEY, OUTPUT_KEY_S
      # Parse output info
      output = arg
    else
      # Ignore
    end
  end

  # Ignore if no operator defined (No input provided)
  return if operator.nil?

  # Execute operations if any
  operator.execute(operations:operations)

  if output.nil?
    # Output result to the command line if no argument for output is provided
    puts operator.result if output.nil?
  else
    # Write and append to output file
    File.write(output, operator.result, mode: 'a')
  end
end