class Postback

  attr_reader :payload, :user 

  def initialize(payload, user_id)
    @payload = payload
    @user = User.find(user_id)
  end

  def process
    case payload
    when "new_thread"
      send_onboard
    end
  end

  def send_onboard
    [
      {
        type: "text",
        text: "They there, #{user.first_name}. I'll send you some awesome venues."
      }, 
      {
        type: "text", 
        text: "Here is a list of the venues closest to you."
      }
    ]
  end
end