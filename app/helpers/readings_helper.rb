module ReadingsHelper
  def username
    @user.email
  end

  def reading_id(reading)
    reading.id || (rand * -10_000).to_i
  end

  def get_hh_mm(time)
    time.strftime('%H:%M')
  end

  def get_date(date)
    date.strftime('%Y-%m-%d')
  end
end
