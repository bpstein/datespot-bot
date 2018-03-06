require 'facebook/messenger'

class Brain
  include Facebook::Messenger

  attr_reader :message, :postback
  attr_reader :sender, :text, :attachments 

  def set_message(message)
    @message = message
    @sender = message.sender
    @text = message.text
    @attachments = message.attachments
  end

  def set_postback(postback)
    @postback = postback 
    @sender = postback.sender
  end

  def start_typing
    Facebook::Client.new.set_typing_on(sender['id'])
  end

  def stop_typing
    Facebook::Client.new.set_typing_off(sender['id'])
  end
end