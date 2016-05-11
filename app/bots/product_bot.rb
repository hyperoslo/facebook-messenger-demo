require 'json'
include Facebook::Messenger

class ProductBot

  attr_accessor :sender, :payload

  def initialize(sender, payload)
    @sender = sender
    @payload = payload
  end

  def buy
    Bot.deliver(
      recipient: sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'receipt',
            recipient_name: 'John Doe',
            order_number: SecureRandom.random_number(100_000).to_s,
            currency: 'GBP',
            payment_method: 'Visa 2345',
            order_url: 'https://asos.com/',
            timestamp: Time.now.to_i,
            elements: [
              {
                title: payload['product_name'],
                subtitle: payload['product_name'],
                quantity: 2,
                price: 50,
                currency: 'GBP',
                image_url: payload['product_image']
              }
            ],
            address: {
              street_1: '1 Hacker Way',
              street_2: 'Coding program',
              city: 'Menlo Park',
              postal_code: '94025',
              state: 'CA',
              country: 'GB'
            },
            summary: {
              subtotal: 75.00,
              shipping_cost: 4.95,
              total_tax: 6.19,
              total_cost: 56.14
            }
          }
        }
      }
    )
  end

  def end_chat
    Bot.deliver(
      recipient: sender,
      message: {
        text: 'Bye! see you another time'
      }
    )
  end

  def ask
    buttons = Product.pluck(:category).uniq.map do |category|
      {
        type: 'postback',
        title: category.capitalize,
        payload: {
          id: 'suggest',
          category: category
        }.to_json
      }
    end

    Bot.deliver(
      recipient: sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: 'What are you looking for?',
            buttons: buttons
          }
        }
      }
    )
  end

  def suggest
    products = Product.where(category: payload['category']).order('RANDOM()')

    Bot.deliver(
      recipient: sender,
      message: {
        text: "Here are some new arrivals in: #{payload['category']}"
      }
    )

    elements = products.map do |product|
      {
        title: product.name,
        subtitle: product.name,
        image_url: product.image,
        buttons: [
          {
            type: 'postback',
            title: 'Buy',
            payload: {
              id: 'buy',
              product_id: product.id,
              product_name: product.name,
              product_image: product.image
            }.to_json
          },
          {
            type: 'postback',
            title: 'Not interested!',
            payload: 'end_chat'
          }
        ]
      }
    end

    Bot.deliver(
      recipient: sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'generic',
            elements: elements.to_json
          }
        }
      }
    )
  end
end

def get_sender_profile(sender)
  request = HTTParty.get(
    "https://graph.facebook.com/v2.6/#{sender['id']}",
    query: {
      access_token: ENV['ACCESS_TOKEN'],
      fields: 'first_name,last_name,gender,profile_pic'
    }
  )

  request.parsed_response
end

def valid?(json)
  JSON.parse(json)
  return true
rescue StandardError
  return false
end

Bot.on :message do |message|
  bot = ProductBot.new(message.sender, message.text)
  sender = get_sender_profile(message.sender)
  puts "*************************"
  puts sender.inspect
  puts "*************************"
  bot.ask
end

Bot.on :postback do |postback|
  payload = postback.payload
  parsed_payload = valid?(payload) ? JSON.parse(payload) : payload

  bot = ProductBot.new(postback.sender, parsed_payload)

  if parsed_payload && parsed_payload['id']
    bot.send(parsed_payload['id'])
  else
    bot.send(parsed_payload)
  end
end
