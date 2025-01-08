class ProjectSet
  def self.from_hash(hash)
    projects = hash[:projects].map { |project_hash| Project.from_hash(project_hash) }
    new(name: hash[:name], projects: projects)
  end

  def initiailize(name: projects:)
    @name = name
    @projects = projects
  end


  # Calculate the total cost of the project set.
  # We are doing this in the scope of the set instead of the individual projects because
  # the individual projects do not know their siblings
  def calculate_total_cost
    # Start by sorting the projects to establish a timeline
    # We will then determine if there is overlap between the projects
    # Once overlaps have been accounted for, we will calculate the cost
  end
end
