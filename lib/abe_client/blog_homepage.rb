require 'abe_client/error'

module AbeClient
  class BlogHomepage

    BlogHomepageQuery = Client.parse <<-'GRAPHQL'
      query($blog:String!) {
        blog(permalink:$blog) {
          name
          description
          color
          features:features(include_empty:false) {
            position
            post {
              title
              url
              published_at
              color
              author {
                display_name
              }
              image(type:thumb800) {
                url
              }
            }
          }

          latest:posts(status:PUBLISHED, limit:5, exclude_featured:true, only_visible:true) {
            title
            url
            published_at
            excerpt
            color
            author {
              display_name
            }
            image(type:thumb400) {
              url
            }
          }

          categories: categories {
            name
            permalink
          }
        }
      }
    GRAPHQL

    def self.get(blog_permalink)
      result = Client.query(BlogHomepageQuery, :variables => {:blog => blog_permalink})
      if result.data.blog
        self.new(result.data)
      elsif !result.errors.empty?
        raise AbeClient::Error, result.errors.messages.map { |k,v| "#{k}: #{v.join(', ')}"}.join("\n")
      else
        nil
      end
    end

    def initialize(data)
      @data = data
    end

    def blog
      @data.blog
    end

    def features
      @data.blog.features.each_with_object({}) do |feature, hash|
        hash[feature.position] = feature.post
      end
    end

    def latest
      @data.blog.latest
    end

    def categories
      @data.blog.categories
    end

  end
end