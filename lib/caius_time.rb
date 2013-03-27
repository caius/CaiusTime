require "active_support/all"
require "nokogiri"
require "open-uri"
require "timeout"
require "core_extends"
require "pathname"

class CaiusTime
  attr_accessor :offset, :time, :diff, :settings

  def initialize params={}
    self.settings = params[:settings]
  end

  def times_for_page page=1
    doc = Nokogiri::XML.parse(open("http://api.twitter.com/1/statuses/user_timeline.xml?screen_name=caius&page=#{page}"))
    doc.css("status").map do |tweet|
      tweet.xpath("created_at").text.to_time.getlocal
    end
  end

  def cache_file
    @cache_file ||= (Pathname.new(settings.root) + "cache/#{Date.today.to_s}.txt")
  end

  def cached_tweet_time
    # Handle nowt in the cache
    return unless File.exists?(cache_file)
    # Return what's in the cache
    str = File.open(cache_file, "r").read.chomp
    # File can exist, but be empty
    return if str.blank?

    p "cache hit"
    Time.parse(str)
  end

  def parse_tweet_time
    Timeout.timeout(5) do
      @page = 1
      until @done
        times_for_page(@page).each do |t|
          if t.to_date.today? && t.hour >= 3
            # Store it and move on
            @time = t
            next
          end
          # we found one older than today!
          @done = true
          break
        end
        @page += 1
      end
    end
    @time
  end

  def fetch_tweet_time
    p "cache miss"
    the_time = parse_tweet_time
    # Write it out to cache it
    File.open(cache_file.to_s, "w") { |f| f.write(the_time) }
    the_time
  end

  def tweet_time
    cached_tweet_time || fetch_tweet_time
  rescue Exception => e #Timeout::Error
    p "Error: #{e.inspect}"
    p e.backtrace
    nil
  end

  def run!
    @time = tweet_time
    return unless @time

    @time = @time.getutc.round(60.minutes).getutc
    diff = ((@time - Time.normal)/60).to_i

    # Store our values for later
    self.offset = offset_from((diff*-1))
    self.time = Time.parse(Time.now.strftime("%Y-%m-%d %H:%M #{offset_from(diff+60)}"))
    self.diff = (Time.now - self.time).to_i/60/60
  end

  def offset_from d
    minutes = d.abs
    hours = 0
    while minutes >= 60
      minutes -= 60
      hours += 1
    end

    sign = (d == d.abs ? "+" : "-")
    "%s%.2d%.2d" % [sign, hours, minutes]
  end

end
