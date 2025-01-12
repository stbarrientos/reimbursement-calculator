require_relative './project'

class ProjectSet
  attr_reader :name, :projects

  def self.from_hash(hash)
    projects = hash['projects'].map { |project_hash| Project.from_hash(project_hash) }
    new(name: hash['name'], projects: projects)
  end

  def initialize(name:, projects:)
    @name = name
    @projects = projects
  end

  def calculate_total_reimbursement
    reimbursement_total = 0

    dates = generate_dates_array
    dates.each_with_index do |date_project_ids, date_index|
      # In the case of a gap between projects, there will be no project ids for the date
      next unless date_project_ids&.any?

      # The first and last days of the project set are always travel days
      if date_index == 0 || date_index == dates.length - 1
        daily_total = calculate_forced_travel_day_rate(date_project_ids)
        reimbursement_total += daily_total
        next
      end

      # Determine the rate for the day based on if there are multiple projects on the same day.
      # This represents and "overlap"
      daily_total =
        if date_project_ids.length == 1
          calculate_single_project_rate(date_project_ids.first, dates, date_index)
        else
          calculate_multi_project_rate(date_project_ids)
        end

      reimbursement_total += daily_total
    end

    reimbursement_total
  end

  private

  # Start date of the first project
  def first_project_set_date
    @first_project_set_date ||= projects.map(&:start_date).min
  end

  # End date of the last project
  def last_project_set_date
    @last_project_set_date ||= projects.map(&:end_date).max
  end

  # Create a simple index for projects to avoid a bloat in #generate_dates_array
  def project_index
    @project_index ||= projects.reduce({}) do |lookup, project|
      lookup.merge(project.object_id => project)
    end
  end

  # Create an array that contains project ids for each date in the project set duration.
  # This is done for performance, to avoid redundant date calculations as in my initial
  # implementation
  def generate_dates_array
    dates = []
    set_duration = last_project_set_date - first_project_set_date
    projects.each do |project|
      project.each_date do |date|
        index = date - first_project_set_date
        dates[index] ||= []
        dates[index] << project.object_id
      end
    end
    dates
  end

  # Given a date and a project id, calculate the rate for the project on that day.
  # This method accounts for neighboring projects.
  def calculate_single_project_rate(project_id, dates, date_index)
    # Retrieve the project from our index
    project = project_index[project_id]

    date = first_project_set_date + date_index

    # If the current day is a full day, we don't need to check for date neighbors
    return project.solo_rate(date) if project.is_full_day?(date)

    # Check the previous and next dates for any projects (excluding_self)
    has_neighbors = find_date_neighbors(project_id, dates, date_index).any?

    # If we don't have date neighbors, we can use the project's solo rate
    return project.solo_rate(date) unless has_neighbors

    # Date neighbors are present, we will use the full date rate.
    if project.is_high_cost_city?
      Project::HIGH_COST_CITY_FULL_DAY_RATE
    else
      Project::LOW_COST_CITY_FULL_DAY_RATE
    end
  end

  def find_date_neighbors(project_id, dates, date_index)
    # We have to check to make sure we don't go out of bounds
    neighbors =
      if date_index == 0
        dates[date_index + 1] || []
      elsif date_index == dates.length - 1
        dates[date_index - 1] || []
      else
        (dates[date_index - 1] || []) + (dates[date_index + 1] || [])
      end

    neighbors.select { |id| id != project_id }
  end

  # Determine the rate for a date on which we have multiple overlapping projects
  def calculate_multi_project_rate(project_ids)
    projects = project_ids.map { |project_id| project_index[project_id] }

    # If any of the overlapping projects are in a high cost city, we'll use the high cost city rate
    if projects.any? { |project| project.is_high_cost_city? }
      Project::HIGH_COST_CITY_FULL_DAY_RATE 
    else
      Project::LOW_COST_CITY_FULL_DAY_RATE
    end
  end

  # Determine the rate for a travel day. We must account for potential overlaps and use the
  # appropriate rate
  def calculate_forced_travel_day_rate(project_ids)
    projects = project_ids.map { |project_id| project_index[project_id] }

    # If any of the overlapping projects are in a high cost city, we'll use the high cost city rate
    if projects.any? { |project| project.is_high_cost_city? }
      Project::HIGH_COST_CITY_TRAVEL_DAY_RATE
    else
      Project::LOW_COST_CITY_TRAVEL_DAY_RATE
    end
  end
end
