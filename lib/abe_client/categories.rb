module AbeClient
  class Categories < Array

    CategoriesQuery = Client.parse <<-'GRAPHQL'
      query ($blog: String!) {
        blog(permalink: $blog) {
          categories {
            name
            permalink
          }
        }
      }
    GRAPHQL

    def self.get(blog)
      result = Client.query(CategoriesQuery, :variables => {:blog => blog})
      if result.data.blog
        new(result.data.blog.categories)
      else
        raise AbeClient::Error, result.errors.messages.map { |k,v| "#{k}: #{v.join(', ')}"}.join("\n")
      end
    end

  end
end
