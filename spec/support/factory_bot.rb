# spec/support/factory_bot.rb

require 'factory_bot'

RSpec.configure do |config|
  FactoryBot.reload
  config.include FactoryBot::Syntax::Methods
end
