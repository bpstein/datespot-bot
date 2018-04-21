class Postback

  attr_reader :payload, :user, :coordinates

  def initialize(obj, user_id)
    @payload = obj.payload
    @coordinates = obj.try(:coordinates)
    @user = User.find(user_id)
  end

  def process
    case payload
    when "new_thread"
      send_onboard
    when 'venues'
      generic_venue_template
    when 'get_directions'
      # ToDo - Needs to add directions
      [{
        type: "text",
        text: "We are working to provide you directions."
      }]
    end
  end

  def send_onboard
    [
      {
        type: "text",
        text: "They there, #{user.first_name}. I'll send you some awesome venues."
      },
      {
        type: "quick_replies",
        text: "Do you want to get venues closest to you ?",
        replies: [
          {
            title: "Send us your location.",
            content_type: "location",
            payload: "user_location"
          }
        ]
      }
    ]
  end

  # Generic template for Venues
  # 1. Get all Venues
  # 2. Get Venue according to coordinate
  def generic_venue_template
    [
      {
        type: 'generic',
        elements: [
           {
            title: "Venue#1",
            image_url: "", # Image URL needs to be added
            subtitle: "Little description of Venue#1",
            default_action: {
              type: "web_url",
              url: "http://www.facebook.com",
              messenger_extensions: false,
              webview_height_ratio: "tall"
            },
            buttons:[
              {
                type: "web_url",
                url: "http://www.facebook.com",
                title: "View Website"
              },{
                type: "postback",
                title: "Get Directions",
                payload: "get_directions"
              }
            ]
          }
        ]
      }
    ]
  end
end