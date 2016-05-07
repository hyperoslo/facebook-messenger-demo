<<<<<<< HEAD
class ProductBot
  def ask(sender)
=======
include Facebook::Messenger

<<<<<<< HEAD
Bot.on :message do |message|
  ask(message.sender)
end
=======
class ProductBot
  def buy(postback)
    payload = JSON.parse(postback.payload)

    Bot.deliver(
      recipient: postback.sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'receipt',
<<<<<<< HEAD
            recipient_name: postback.sender,
            order_number: postback.sender,
=======
            recipient_name: 'John Doe',
            order_number: SecureRandom.random_number(10000000).to_s,
>>>>>>> 15c252e... Fix order number
            currency: 'GBP',
            payment_method: "Visa 2345",
            order_url: "http://petersapparel.parseapp.com/order?order_id=123456",
            timestamp: Time.now,
            elements:[
              {
                title: payload["product_name"],
                subtitle: payload["product_name"],
                quantity: 2,
                price: 50,
                currency: "GBP",
                image_url: payload["product_image"]
              },
            ],
            address:{
              street_1: "1 Hacker Way",
              street_2: "Coding program",
              city: "Menlo Park",
              postal_code: "94025",
              state: "CA",
              country: "GB"
            },
            summary:{
              subtotal: 75.00,
              shipping_cost: 4.95,
              total_tax: 6.19,
              total_cost: 56.14
            },
            adjustments:[
              {
                name: "New Customer Discount",
                amount: 20
              },
              {
                name: "$10 Off Coupon",
                amount: 10
              }
            ]
          }
        }
      }
    )
  end
>>>>>>> 8343e37... Add buy reciept

Bot.on :postback do |postback|
  case postback.payload
  when 'accessories'
    suggest(postback)
  when 'clothing'
    suggest(postback)
  when 'footwear'
    suggest(postback)
  else
    send_product_image(postback)
  end
end

def ask(sender)
  Bot.deliver(
    recipient: sender,
    message: {
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: "What are you looking for?",
          buttons: Product.pluck(:category).uniq.map {|category|
            {
              type: 'postback',
              title: category.capitalize,
              payload: category
            }
          }
        }
      }
    }
  )
end

def suggest(postback)
  products = Product.where(category: postback.payload).order('RANDOM()')
  products.each do |product|
>>>>>>> 112853d... include bot module
    Bot.deliver(
      recipient: sender,
      message: {
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: "What are you looking for?",
            buttons: Product.pluck(:category).uniq.map {|category|
              {
                type: 'postback',
                title: category.capitalize,
                payload: category
              }
            }
          }
        }
      }
    )
  end

  def suggest(postback)
    products = Product.where(category: postback.payload).order('RANDOM()')
    products.each do |product|
      Bot.deliver(
        recipient: postback.sender,
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: product.name,
              buttons: [
                {
                  type: 'postback',
                  title: 'See more',
                  payload: product.id
                }
              ]
            }
          }
        }
      )
    end
  end


  def send_product_image(postback)
    product = Product.find(postback.payload)

    Bot.deliver(
      recipient: postback.sender,
      message: {
        text: "Here is the image for #{product.name}: ",
      }
    )

    Bot.deliver(
      recipient: postback.sender,
      message: {
        attachment: {
          type: 'image',
          payload: {
            url: product.image
          }
        }
      }
    )
  end

  Bot.on :message do |message|
    ask(message.sender)
  end

  Bot.on :postback do |postback|
    case postback.payload
    when 'accessories'
      suggest(postback)
    when 'clothing'
      suggest(postback)
    when 'footwear'
      suggest(postback)
    else
      send_product_image(postback)
    end
  end
end
