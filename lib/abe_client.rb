require "graphql/client"
require "graphql/client/http"

module AbeClient

  class << self

    # Return the API token to use to authenticate to the API
    def api_token
      @api_token || ENV['ABE_GRAPHQL_API_TOKEN']
    end
    attr_writer :api_token

    # Return the endpoint to communicate with
    def endpoint
      @endpoint || ENV['ABE_GRAPHQL_ENDPOINT'] || "https://atech.blog/graphql"
    end
    attr_writer :endpoint

    # Return the path to the schema file
    def schema_path
      File.expand_path(File.join('..', '..', 'schema.json'), __FILE__)
    end

  end

  # Define an HTTP transport for communicating with the server
  HTTP = GraphQL::Client::HTTP.new(AbeClient.endpoint) do
    def headers(context)
      {'X-API-Token' => AbeClient.api_token}
    end
  end

  # Load the schema from the file system
  if File.exist?(AbeClient.schema_path)
    Schema = GraphQL::Client.load_schema(AbeClient.schema_path)
  else
    Schema = GraphQL::Client.load_schema(HTTP)
  end

  # Create a client for the schema & created HTTP endpoint
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)

end

require 'abe_client/blog_homepage'
require 'abe_client/post'
require 'abe_client/posts'
require 'abe_client/category_posts'
require 'abe_client/rss_feed'
