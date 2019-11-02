object false

node(:current_page) { @posts.current_page }
node(:total_count) { @posts.total_count }
node(:total_pages) { @posts.total_pages }

child @posts do
  extends "api/v1/posts/show"
end
