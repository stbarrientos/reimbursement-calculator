require_relative './common'
require_relative '../src/project'

ts = TestSuite.new

ts.test "Project can be initialized correctly from hash" do
  proj = Project.from_hash({
    'start_date' => '9/1/2025',
    'end_date' => '9/3/2025',
    'city' => 'High Cost City'
  })
  (
    proj.start_date == Date.strptime('9/1/2025', '%m/%d/%Y') &&
    proj.end_date == Date.strptime('9/3/2025', '%m/%d/%Y') &&
    proj.duration == 3 &&
    proj.city_type == Project::HIGH_COST_CITY_TYPE
  )
end

ts.test "Project contains_date? can correctly determine if a date is within the project" do
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/1/2025', city_type: 'High Cost City')
  proj2 = Project.new(start_date: '9/4/2025', end_date: '9/8/2025', city_type: 'High Cost City')
  (
    proj1.contains_date?(Date.strptime('9/1/2025', '%m/%d/%Y')) &&
    proj2.contains_date?(Date.strptime('9/5/2025', '%m/%d/%Y')) &&
    !proj1.contains_date?(Date.strptime('9/5/2025', '%m/%d/%Y')) &&
    !proj2.contains_date?(Date.strptime('9/1/2025', '%m/%d/%Y'))
  )
end

ts.test "Project is_full_day? can correctly determine if a date is a full day" do
  proj = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  (
    proj.is_full_day?(Date.strptime('9/2/2025', '%m/%d/%Y')) &&
    !proj.is_full_day?(Date.strptime('9/1/2025', '%m/%d/%Y')) &&
    !proj.is_full_day?(Date.strptime('9/6/2025', '%m/%d/%Y'))
  )
end

ts.test "Project is_travel_day? can correctly determine if a date is a travel day" do
  proj = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  (
    proj.is_travel_day?(Date.strptime('9/1/2025', '%m/%d/%Y')) &&
    !proj.is_travel_day?(Date.strptime('9/2/2025', '%m/%d/%Y')) &&
    !proj.is_travel_day?(Date.strptime('9/6/2025', '%m/%d/%Y'))
  )
end

ts.test "Project solo_rate returns the correct rate for the given day" do
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  proj2 = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'Low Cost City')
  proj3 = Project.new(start_date: '9/3/2025', end_date: '9/3/2025', city_type: 'Low Cost City')
  (
    proj1.solo_rate(Date.strptime('9/1/2025', '%m/%d/%Y')) == 75 &&
    proj1.solo_rate(Date.strptime('9/2/2025', '%m/%d/%Y')) == 85 &&
    proj1.solo_rate(Date.strptime('9/6/2025', '%m/%d/%Y')) == 0 &&
    proj2.solo_rate(Date.strptime('9/1/2025', '%m/%d/%Y')) == 45 &&
    proj2.solo_rate(Date.strptime('9/2/2025', '%m/%d/%Y')) == 55 &&
    proj2.solo_rate(Date.strptime('9/6/2025', '%m/%d/%Y')) == 0 &&
    proj3.solo_rate(Date.strptime('9/3/2025', '%m/%d/%Y')) == 55
  )
end

ts.run