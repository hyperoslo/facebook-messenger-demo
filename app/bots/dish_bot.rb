include Facebook::Messenger
dishes = [
  {
    name: 'lun brokkolisalat med kylling og feta',
    image: 'https://www.rema.no/remaws/rest/convert/RemaProductCatalog/Online/Rema1000-15mars-1631337_crop_34511_tif_raw?w=650&q=75',
    description: 'Det tar 30 minutter. Eple, brokkoli, yoghurt og feta – det er mange gode smaker!',
    ingredients: <<-EOT.gsub(/^\s+/, '')
      Dette må du kjøpe:
      * 80 g Fetaost, mild
      * 2 dl Yoghurt naturell
      * 500 g Lårfilet av kylling
      * 3 dl Jasminris
      Dette har du kanskje allerede:
      * 2 ss Olje til steking
      * 1 ss Maizena
      * 0,5 ts Salt
      * 1 klype Nykvernet pepper
      * 1 ss Hvitvinseddik
    EOT
  },
  {
    name: 'grillspyd med greske smaker',
    image: 'https://www.rema.no/remaws/rest/convert/RemaProductCatalog/Online/Grillspyd%20med%20greske%20smaker%20og%20ciabatta-16mars31446_crop_34509_tif_raw?w=650&q=75',
    description: 'På gresk heter det "souvlaki". Dette er en fornorsket versjon, og minst like god!',
    ingredients: <<-EOT.gsub(/^\s+/, '')
      Dette må du kjøpe:
      * 2 stk Tomater
      * 1 stk Grønn paprika
      * 3 fedd Hvitløk
      * 500 g Kjøttdeig av svin og storfe
      * 1 pakke Fine rundstykker
      Dette har du kanskje allerede:
      * 1 ss Olje til pensling
      * 1 klype Nykvernet pepper
      * 0,5 ts Oregano
    EOT
  }
]

def suggest(sender)
  dish = dishes.sample

  Bot.deliver(
    recipient: sender,
    message: {
      text: "Du virker sulten! Hva med #{dish[:name]}?",
    }
  )

  Bot.deliver(
    recipient: sender,
    message: {
      attachment: {
        type: 'image',
        payload: {
          url: dish[:image]
        }
      }
    }
  )

  Bot.deliver(
    recipient: sender,
    message: {
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: dish[:description],
          buttons: [
            {
              type: 'postback',
              title: 'Ja, perfekt!',
              payload: 'YES'
            },
            {
              type: 'postback',
              title: 'Har du noe annet?',
              payload: 'NO'
            }
          ]
        }
      }
    }
  )
end

Bot.on :message do |message|
  suggest(message.sender)
end

Bot.on :postback do |postback|
  case postback.payload
  when 'YES'
    text = dish[:ingredients]
  when 'NO'
    suggest(postback.sender)
  end

  Bot.deliver(
    recipient: postback.sender,
    message: {
      text: text
    }
  )
end
