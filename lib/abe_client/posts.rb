module AbeClient
  class Posts < Array

    PostsQuery = Client.parse <<-'GRAPHQL'
      query($blog: String!, $page: Int!, $per_page: Int) {
        blog(permalink: $blog) {
          posts(page: $page, per_page: $per_page) {
            page_info {
              total_records
            }
            posts {
              id
              title
              excerpt
              url
              color
              published_at
              image(type: thumb800) {
                url
              }
              icon {
                url
              }
              author {
                display_name
              }
            }
          }
        }
      }
    GRAPHQL

    def self.get(blog, page, options = {})
      result = Client.query(PostsQuery, :variables => {:blog => blog, :page => page, :year => options[:year], :month => options[:month], :per_page => options[:per_page] || 12})
      if result.data.blog
        self.new(result.data.blog.posts.posts, result.data.blog.posts.page_info)
      else
        puts result.inspect
        raise AbeClient::Error, result.errors.messages.map { |k,v| "#{k}: #{v.join(', ')}"}.join("\n")
      end
    end

    def initialize(array, page_info)
      @page_info = page_info
      super(array.to_a)
    end

    def total_posts
      @page_info.total_records
    end

  end
end
