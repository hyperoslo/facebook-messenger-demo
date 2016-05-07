# Facebook Messenger Demo

A demo chat bot running on heroku. For actual interaction, try messaging on this page: https://www.facebook.com/chatbotmessenger/

The demo uses [Facebook Messenger](https://github.com/hyperoslo/facebook-messenger) gem, which is a Ruby client for Bots on Messenger

```bash
git clone git@github.com:hyperoslo/facebook-messenger-demo.git
cd facebook-messenger-demo
bundle install
bundle exec rake db:migrate db:create db:seed
bundle exec rails s
```
