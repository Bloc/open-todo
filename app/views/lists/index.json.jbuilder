json.array!(@lists) do |list|
  json.extract! list, :id, :name, :user_id, :permissions
  json.url list_url(list, format: :json)
end
