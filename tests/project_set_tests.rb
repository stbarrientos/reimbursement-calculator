require 'json'
require_relative './common'
require_relative '../src/project_set'

ts = TestSuite.new

ts.test "ProjectSet can calculate total cost for a single project correctly" do
  proj = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'High Cost City')
  proj_set = ProjectSet.new(name: 'Test Project Set', projects: [proj])
  proj_set.calculate_total_cost == 235
end

ts.test "ProjectSet can calculate total cost for single day projects correctly" do
  proj = Project.new(start_date: '9/1/2025', end_date: '9/1/2025', city_type: 'High Cost City')
  proj_set = ProjectSet.new(name: 'Test Project Set', projects: [proj])
  proj_set.calculate_total_cost == 85
end

ts.test "ProjectSet can calculate total cost for multiple projects correctly" do
  # Estimated value: 55
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/1/2025', city_type: 'Low Cost City')

  # Estimated value: 75 + 85 + 75 = 235
  proj2 = Project.new(start_date: '9/3/2025', end_date: '9/5/2025', city_type: 'High Cost City')

  # Estimated value: 45 + 55 + 55 + 55 + 55 + 45 = 310
  proj3 = Project.new(start_date: '9/7/2025', end_date: '9/12/2025', city_type: 'Low Cost City')

  proj_set = ProjectSet.new(name: 'Test Project Set', projects: [proj1, proj2, proj3])
  proj_set.calculate_total_cost == 600
end

ts.test "ProjectSet accounts for date neighbors when calculating cost" do
  # Estimated value: 55
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/1/2025', city_type: 'Low Cost City')

  # Estimated value: 85 + 85 + 85 + 85 = 340
  proj2 = Project.new(start_date: '9/2/2025', end_date: '9/5/2025', city_type: 'High Cost City')

  # Estimated value: 55 + 45 = 100
  proj3 = Project.new(start_date: '9/6/2025', end_date: '9/7/2025', city_type: 'Low Cost City')

  proj_set = ProjectSet.new(name: 'Test Project Set', projects: [proj1, proj2, proj3])
  proj_set.calculate_total_cost == 495
end

ts.test "ProjectSet accounts for project overlaps when calculating cost" do
  # Estimated value: 55
  proj1 = Project.new(start_date: '9/1/2025', end_date: '9/3/2025', city_type: 'Low Cost City')

  # Estimated value: 85 + 85 + 85 + 85 = 340
  proj2 = Project.new(start_date: '9/2/2025', end_date: '9/5/2025', city_type: 'High Cost City')

  # Estimated value: 55 + 45 = 100
  proj3 = Project.new(start_date: '9/5/2025', end_date: '9/7/2025', city_type: 'Low Cost City')

  proj_set = ProjectSet.new(name: 'Test Project Set', projects: [proj1, proj2, proj3])
  proj_set.calculate_total_cost == 495
end

ts.test "reimbursements can be correctly calculated from input.json" do
  json = JSON.parse(File.read('./input.json'))
  totals = json['sets'].map do |json_set|
    ProjectSet.from_hash(json_set).calculate_total_cost
  end
  totals == [145, 580, 475, 225]
end

ts.run