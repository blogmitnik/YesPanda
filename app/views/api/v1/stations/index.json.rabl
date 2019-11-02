object false

node(:current_page) { @stations.current_page }
node(:total_count) { @stations.total_count }
node(:total_pages) { @stations.total_pages }

child @stations do
  extends "api/v1/stations/show"
end
