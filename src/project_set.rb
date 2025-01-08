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


  # Calculate the total cost of the project set.
  # We are doing this in the scope of the set instead of the individual projects because
  # the individual projects do not know their siblings
  def calculate_total_cost
    reimbursement_total = 0

    # We'll create a range of days for the project set
    set_duration = last_project_set_date - first_project_set_date

    # Going through each day in the range, we'll determine which rate applies
    (set_duration.to_i + 1).times do |day_offset|
      current_date = first_project_set_date + day_offset

      # Find all projects that have the current date in their duration
      applicable_projects = projects.select { |project| project.contains_date?(current_date) }

      # If there are no applicable projects, there is no rate for the day
      next if applicable_projects.empty?

      daily_total = if applicable_projects.length == 1
                      calculate_single_project_rate(applicable_projects.first, current_date)
                    else
                      calculate_multi_project_rate(applicable_projects, current_date)
                    end

      reimbursement_total += daily_total
    end

    reimbursement_total
  end

  # Start date of the first project
  def first_project_set_date
    @first_project_set_date ||= projects.map(&:start_date).min
  end

  # End date of the last project
  def last_project_set_date
    @last_project_set_date ||= projects.map(&:end_date).max
  end

  private

  def calculate_single_project_rate(project, date)
    # If the current day is a full day, we don't need to check for date neighbors
    return project.solo_rate(date) if project.is_full_day?(date)

    # Determine whether or not we have any date neighbors
    has_neighbors = self.projects.any? do |other_project|
      # We are relying on ruby object id comparison here. Ideally, this would be a stored primary
      # key, but for now this will work.
      next if other_project == project

      other_project.contains_date?(date - 1) || other_project.contains_date?(date + 1)
    end

    # If we don't have date neighbors, we can use the project's solo rate
    return project.solo_rate(date) unless has_neighbors

    # Date neighbors are present, we will use the full date rate.
    if project.is_high_cost_city?
      Project::HIGH_COST_CITY_FULL_DAY_RATE
    else
      Project::LOW_COST_CITY_FULL_DAY_RATE
    end
    
  end

  def calculate_multi_project_rate(projects, date)
    # If any of the overlapping projects are in a high cost city, we'll use the high cost city rate
    if projects.any? { |project| project.is_high_cost_city? }
      Project::HIGH_COST_CITY_FULL_DAY_RATE 
    else
      Project::LOW_COST_CITY_FULL_DAY_RATE
    end
  end
end
