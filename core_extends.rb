class Date
  def today?
    self == Date.today
  end
end


class Time
  def today?
    to_date.today?
  end

  def self.normal
    parse("09:00").getutc
  end

  def round(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

end
