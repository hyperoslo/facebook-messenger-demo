# Facebook Messenger Demo

[![Join the chat at https://gitter.im/hyperoslo/facebook-messenger-demo](https://badges.gitter.im/hyperoslo/facebook-messenger-demo.svg)](https://gitter.im/hyperoslo/facebook-messenger-demo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

A demo chat bot running on heroku. For actual interaction, try messaging on this page: https://www.facebook.com/chatbotmessenger/ (only works for testers, so just send a message and I will add you to testers list)

The demo uses [Facebook Messenger](https://github.com/hyperoslo/facebook-messenger) gem, which is a Ruby client for Bots on Messenger

```bash
git clone git@github.com:hyperoslo/facebook-messenger-demo.git
cd facebook-messenger-demo
bundle install
bundle exec rake db:migrate db:create db:seed
bundle exec rails s
```
