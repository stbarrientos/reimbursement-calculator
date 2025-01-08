require_relative './common'
require_relative '../src/project.rb'

ts = TestSuite.new

ts.test "Project can be initialized correctly from hash" do
  proj = Project.from_hash({
    start_date: '9/1/2025',
    end_date: '9/3/2025',
    city_type: 'High Cost City'
  })
  proj.start_date == Date.strptime('9/1/2025', '%m/%d/%Y') &&
    proj.end_date == Date.strptime('9/3/2025', '%m/%d/%Y') &&
    proj.duration == 3 &&
    proj.city_type == Project::HIGH_COST_CITY_TYPE
end

ts.test "Project can calculate travel day count" do
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  proj2 = Project.new(start_date: '9/1/2025', end_date: '9/1/2025', city_type: 'High Cost City')
  proj3 = Project.new(start_date: '9/5/2025', end_date: '10/3/2025', city_type: 'High Cost City')
  proj1.travel_day_count == 2 && proj2.travel_day_count == 1 && proj3.travel_day_count == 2
end

ts.test "Project can calculate full day count" do
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  proj2 = Project.new(start_date: '9/1/2025', end_date: '9/1/2025', city_type: 'High Cost City')
  proj3 = Project.new(start_date: '9/5/2025', end_date: '10/3/2025', city_type: 'High Cost City')
  proj1.full_day_count == 1 && proj2.full_day_count == 0 && proj3.full_day_count == 27
end

ts.test "Project can tell when an overlap occurs" do
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  proj2 = Project.new(start_date: '9/3/2025', end_date: '9/5/2025', city_type: 'High Cost City')
  proj1.overlaps?(proj2) && proj2.overlaps?(proj1)
end

ts.test "Project can tell when an overlap does not occur" do
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  proj2 = Project.new(start_date: '9/4/2025', end_date: '9/5/2025', city_type: 'High Cost City')
  !proj1.overlaps?(proj2)
end

ts.xtest "ProjectSet can calculate total cost for a single project correctly" do
end

ts.xtest "ProjectSet can calculate total cost for multiple projects correctly" do
end

ts.xtest "reimbursements can be correctly calculated from input.json" do
end

ts.run