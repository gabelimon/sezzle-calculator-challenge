# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Initialize the logger
Rails.logger = Logger.new(STDOUT)
