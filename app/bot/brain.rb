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

  def process_message
    
  end

  def process_postback
    
  end

  def create_log
    if message.present? 
      Log.create(
        user_id: user.id,
        fb_message_id: message.id, 
        message_type: message_type,
        sent_at: message.sent_at
      )
    else 
      Log.create(
        user_id: user.id, 
        message_type: "postback",
        sent_at: postback.sent_at
      )
    end
  end

  private

  def message_type
    text.present? ? "text" : attachments.first["type"]
  end

  def user 
    @user ||= set_user
  end

  def set_user
    @user = User.find_by(fb_id: sender['id'])
      
    if @user.nil?
      fb_user = Facebook::Client.new.get_user(sender["id"])
      @user = User.create(
        fb_id: sender["id"],
        full_name: fb_user["first_name"] + " " + fb_user["last_name"],
        gender: fb_user["gender"],
        locale: fb_user["locale"],
        timezone: fb_user["timezone"]
      )
    end

    @user 
  end
end
