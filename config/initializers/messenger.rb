require 'facebook/messenger'

if Rails.env.production?
  Dir["#{Rails.root}/app/bots/**/*.rb"].each { |file| require file }
end

Facebook::Messenger.configure do |config|
  config.access_token = ENV['ACCESS_TOKEN']
  config.verify_token = ENV['VERIFY_TOKEN']
end

Facebook::Messenger::Subscriptions.subscribe
