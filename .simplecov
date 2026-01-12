# .simplecov

SimpleCov.start 'rails' do
  # Minimum coverage threshold
  minimum_coverage 80
  minimum_coverage_by_file 70

  # Refuse coverage drop
  # refuse_coverage_drop :line, 50

  # Coverage groups
  add_group 'Controllers', 'app/controllers'
  add_group 'Services', 'app/services'
  add_group 'Domain', 'app/domain'
  add_group 'Repositories', 'app/repositories'
  add_group 'Workers', 'app/workers'

  # Filters
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
end