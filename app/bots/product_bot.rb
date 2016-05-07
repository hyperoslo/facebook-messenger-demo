class ProductBot
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
