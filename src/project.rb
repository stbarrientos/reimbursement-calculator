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
    new(**hash)
  end

  def initialize(start_date:, end_date:, city_type:)
    @start_date = Date.strptime(start_date, '%m/%d/%Y')
    @end_date = Date.strptime(end_date, '%m/%d/%Y')
    @city_type = city_type
    @duration = calculate_duration
  end

  def travel_day_count
    # The first and last day of a project are always travel days. However, a project can be only 1 day long
    if duration > 2
      2
    else
      duration
    end
  end

  def full_day_count
    full_days = duration - travel_day_count
    if full_days > 0
      full_days
    else
      0
    end
  end

  def overlaps?(other_project)
    # If the other project ends after ours starts, that's an overlap
    return true if start_date >= other_project.end_date

    # If the other project starts before ours ends, that's an overlap
    return true if end_date >= other_project.start_date

    false
  end

  def is_high_cost_city?
    @city_type == HIGH_COST_CITY_TYPE
  end

  def is_low_cost_city?
    @city_type == LOW_COST_CITY_TYPE
  end

  # For easier sorting
  def <=>(other_project)
    start_date <=> other_project.start_date
  end

  private

  def calculate_duration
    # Classic off by one: we want to include the start and end dates in the duration
    (@end_date - @start_date).to_i + 1
  end
end
