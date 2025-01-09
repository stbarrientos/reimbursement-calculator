require 'date'

class Project
  HIGH_COST_CITY_TYPE = 'High Cost City'
  LOW_COST_CITY_TYPE = 'Low Cost City'

  LOW_COST_CITY_FULL_DAY_RATE = 55
  LOW_COST_CITY_TRAVEL_DAY_RATE = 45
  HIGH_COST_CITY_FULL_DAY_RATE = 85
  HIGH_COST_CITY_TRAVEL_DAY_RATE = 75

  attr_reader :start_date, :end_date, :duration, :city_type

  def self.from_hash(hash)
    # Avoiding splatting the hash into keyword args for now
    new(start_date: hash['start_date'], end_date: hash['end_date'], city_type: hash['city'])
  end

  def initialize(start_date:, end_date:, city_type:)
    @start_date = Date.strptime(start_date, '%m/%d/%Y')
    @end_date = Date.strptime(end_date, '%m/%d/%Y')
    @city_type = city_type
    @duration = calculate_duration
  end

  def each_date(&block)
    duration.times do |date_offest|
      block.call(start_date + date_offest)
    end
  end

  def contains_date?(date)
    start_date <= date && end_date >= date
  end

  def is_full_day?(date)
    return false unless contains_date?(date)

    date != start_date && date != end_date
  end

  def is_travel_day?(date)
    return false unless contains_date?(date)
    !is_full_day?(date)
  end

  def is_high_cost_city?
    @city_type == HIGH_COST_CITY_TYPE
  end

  # This method is used to calculate the rate for a single project on a given day.
  # NOTE: This method does not attempt to return the final rate for a project in the context of a set.
  # See ProjectSet#calculate_total_reimbursement for the logic used to calculate project set total
  def solo_rate(date)
    if is_full_day?(date)
      is_high_cost_city? ? HIGH_COST_CITY_FULL_DAY_RATE : LOW_COST_CITY_FULL_DAY_RATE
    elsif is_travel_day?(date)
      is_high_cost_city? ? HIGH_COST_CITY_TRAVEL_DAY_RATE : LOW_COST_CITY_TRAVEL_DAY_RATE
    else
      # This final condition will only be hit if we attempt to calculate the solo rate for a date outside of
      # the project's duration. This should never happen.
      0
    end
  end

  private

  def calculate_duration
    # Classic off by one: we want to include the start and end dates in the duration
    (@end_date - @start_date).to_i + 1
  end
end
