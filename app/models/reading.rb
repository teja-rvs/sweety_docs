class Reading < ApplicationRecord
  DAILY_LIMIT = 4

  scope :today, -> { where('recorded_at >= ?', DateTime.now.beginning_of_day) }
  scope :month_to_date, ->(end_date) { where('recorded_at >= ? AND recorded_at <= ?', DateTime.now.at_beginning_of_month.beginning_of_day, end_date.to_date.at_end_of_day) }
  scope :monthly, -> { where('recorded_at >= ?', DateTime.now.months_ago(1).beginning_of_day) }
  scope :order_by_data, -> { order(data: :asc) }
  scope :order_by_time, -> { order(recorded_at: :asc) }

  belongs_to :user

  validates :data, presence: true, numericality: { only_integer: true }
  validates :recorded_at, presence: true
  validate :daily_limit?, on: :create

  def daily_limit?
    errors.add(:daily_limit, 'Daily Limit Reached') if user.readings.today.size > (DAILY_LIMIT - 1)
  end

  def genereate_sample_data
    start_date = Date.parse('2022-1-1')
    end_date = Date.today
    (start_date..end_date).each do |day|
      DAILY_LIMIT.times do
        Reading.create!(
          user_id: 1,
          data: rand(140..170),
          recorded_at: "#{day} #{rand(6..22)}:00"
        )
      end
    end
  end

  def self.create_or_update_daily_readings(readings, user)
    errors = {}
    error_flag = false
    readings.each do |id, reading|
      record = new_or_existing_record(id, user.id)
      record.data = reading[:data]
      record.recorded_at = reading[:recorded_at].to_time
      if record.valid?
        record.save!
      else
        error_flag = true
        errors[id] = error_messages(record.errors)
        errors[:daily_limit] = record.errors[:daily_limit].first
      end
    end
    [errors, error_flag]
  end

  def self.error_messages(errors)
    {
      data: errors[:data].first,
      recorded_at: errors[:recorded_at].first
    }
  end

  def self.new_or_existing_record(id, user_id)
    return Reading.find_by_id(id) if id.to_i.positive?

    Reading.new(user_id: user_id)
  end

  def self.delete_daily_readings(readings, user)
    delete_reading_ids = user.readings.today.ids - readings.keys&.map(&:to_i)
    Reading.where(id: delete_reading_ids).destroy_all unless delete_reading_ids.blank?
  end
end
