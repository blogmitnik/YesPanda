object false

node(:current_page) { @reports.current_page }
node(:total_count) { @reports.total_count }
node(:total_pages) { @reports.total_pages }

child @reports do
  extends "api/v1/reports/show"
end
