$redis = if Rails.env.production?
  Redis.new(url: ENV["REDIS_URL"])
else
  Redis.new(url: "redis://localhost:6379")
end
