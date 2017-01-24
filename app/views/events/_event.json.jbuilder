json.extract! event, :id, :name, :time, :place, :purpose, :created_at, :updated_at
json.url event_url(event, format: :json)