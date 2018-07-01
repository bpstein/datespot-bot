require 'facebook/messenger'

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe

Bot.on :message do |message|
  brain = Brain.new
  brain.set_message(message)
  brain.start_typing
  brain.create_log
  brain.process_message
  brain.stop_typing
end

Bot.on :postback do |postback|
  brain = Brain.new
  brain.set_postback(postback)
  brain.start_typing
  brain.create_log
  brain.process_postback
  brain.stop_typing
end

# Postback for pressing the 'Get Started' button
Facebook::Messenger::Thread.set(
  setting_type: "call_to_actions",
  thread_state: "new_thread",
  call_to_actions: [
    {
      payload: "new_thread"
    }
  ]
)

# Persistent menu at bottom of chat window
Facebook::Messenger::Thread.set(
  persistent_menu: [
    {
      locale: "default",
      composer_input_disabled: true,
      call_to_actions:[
        {
          type: "web_url",
          title: "Powered by DateSpot",
          url: "http://datespot.co",
          webview_height_ratio: "full"
        }
      ]
    }
  ]
)