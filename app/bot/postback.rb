require 'rest-client'
class Postback

  attr_reader :payload, :user, :coordinates

  def initialize(obj, user_id)
    @payload = obj.payload
    @coordinates = obj.try(:coordinates)
    @user = User.find(user_id)
  end

  def process(text)
    case payload
    when "new_thread"
      send_onboard
    when 'venues'
      venues = get_venues(text)
      if venues.empty?
        [{
          type: "text",
          text: "Currently, we don't have any venues for this location. Try at some other location."
        }]
      else
        generic_venue_template(venues)
      end
    when 'get_directions'
      # ToDo - Needs to add directions
      [{
        type: "text",
        text: "We are working to provide you directions."
      }]
    end
  end

  private

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
  def generic_venue_template(venues)
    [
      {
        type: 'generic',
        elements: venues.map do |venue|
           {
            title: venue["name"],
            image_url: venue["image_url"],
            subtitle: venue["short_description"],
            default_action: {
              type: "web_url",
              url: venue["website"],
              messenger_extensions: false,
              webview_height_ratio: "tall"
            },
            buttons:[
              {
                type: "web_url",
                url: venue["website"],
                title: "View Website"
              },{
                type: "postback",
                title: "Get Directions",
                payload: "get_directions"
              }
            ]
          }
        end
      }
    ]
  end

  def get_venues(location)
    params = {}
    if self.respond_to?(:coordinates)
      coordinates.each do |loc|
        params[:location][] = loc
      end
    else
      location_txt = text.to_s.match(/venue.?\s*near.?\s+(.+)/i)
      params[:search] = location_txt if location_txt
    end
    begin
      venues = RestClient.get("#{ENV['DATESPOT_API_HOST']}/datespots", {params: params}).body
    rescue Exception => e
      venues = []
    end
    JSON.parse(venues)
  end
end