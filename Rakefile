task :get_schema do
  require 'abe_client/client'
  client = AbeClient::Client.new(ENV['ENDPOINT'] || "https://atech.blog/graphql", ENV['API_TOKEN'])
  client.cache_schema!
end
