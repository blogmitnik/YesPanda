job_type :rake, "cd :path && rvm use system && :environment_variable=:environment rake :task --silent :output"
job_type :command, ":task :output"
job_type :runner,  "cd :path && bin/rails runner -e :environment ':task' :output"
job_type :script,  "cd :path && :environment_variable=:environment bundle exec script/:task :output"

# Using 24 hour clock instead of the default 12 hour clock
set :chronic_options, :hours24 => true

# Define date & time period to execute crontab
every :day, :at => '14:06' do
  rake "import_csv"
end

every :day, :at => (12..14).to_a.map { |x| ["#{x}:00","#{x}:30", "#{x+1}:00"] }.flatten do
  rake "import_csv"
end