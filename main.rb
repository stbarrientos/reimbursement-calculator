require 'json'
require_relative './src/project_set'

json = JSON.parse(File.read('input.json'))
json['sets'].each do |json_set|

  project_set = ProjectSet.from_hash(json_set)
  total_reimbursement = project_set.calculate_total_reimbursement
  puts "#{project_set.name} reimbursement: $#{total_reimbursement}.00"
end
