object @station

attributes :id, :name

node(:created_at) { |p| p.created_at.iso8601 }
node(:updated_at) { |p| p.updated_at.iso8601 }