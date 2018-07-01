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
    if message.messaging["message"]["quick_reply"].present?
      @postback = OpenStruct.new({ payload: message.messaging["message"]["quick_reply"]["payload"] })
      process_postback
    elsif text.present?
      case text
      when /venue/i
        @postback = OpenStruct.new({ payload: 'venues' })
        process_postback(text)
      else
        send_text("Hi #{user.first_name}!")
      end
    elsif message_type == 'location'
      @postback = OpenStruct.new({ payload: 'venues', coordinates: attachments.first['payload']['coordinates'] })
      process_postback
    else
      send_text("Sorry, I don't handle attachments :(")
    end
  end

  def process_postback(text=nil)
    resp = Postback.new(postback, user.id).process(text)
    resp.each do |r|
      case r[:type]
      when "text"
        send_text(r[:text])
      when "generic"
        send_generic_template(r[:elements])
      when "quick_replies"
        send_quick_replies(r[:text], r[:replies])
      else
        fail "Invalid type"
      end
    end
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

  def send_text(text)
    Bot.deliver(
      recipient: sender,
      sender_action: "typing_on",
      message: {
        text: text
      }
    )
  end

  def send_quick_replies(text, quick_replies)
    Bot.deliver(
      recipient: sender,
      sender_action: "typing_on",
      message: {
        text: text,
        quick_replies: quick_replies
      }
    )
  end

  def send_generic_template(elements)
    Bot.deliver(
      recipient: sender,
      sender_action: "typing_on",
      message: {
        attachment: {
          type: "template",
          payload: {
            template_type: "generic",
            elements: elements
          }
        }
      }
    )
  end

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
      full_name = if fb_user['name'].present?
                    fb_user['name'].to_s
                  else
                    "#{fb_user['first_name']} #{fb_user['last_name']}"
                  end
      @user = User.create(
        fb_id: fb_user["id"],
        full_name: full_name,
        gender: fb_user["gender"],
        locale: fb_user["locale"],
        timezone: fb_user["timezone"]
      )
    end

    @user
  end
end
