task :get_schema do
  require 'graphql/client'
  require 'graphql/client/http'
  HTTP = GraphQL::Client::HTTP.new('https://atech.blog/graphql') do
    def headers(context)
      {'X-API-Token' => ENV['API_TOKEN']}
    end
  end
  GraphQL::Client.dump_schema(HTTP, File.expand_path('../schema.json', __FILE__))
end
