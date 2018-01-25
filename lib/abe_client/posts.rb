module AbeClient
  class Posts < Array

    PostsQuery = Client.parse <<-'GRAPHQL'
      query($blog: String!, $page: Int!, $per_page: Int, $categories: [String!], $month: Int, $year: Int) {
        blog(permalink: $blog) {
          posts(page: $page, per_page: $per_page, categories: $categories, month: $month, year: $year) {
            page_info {
              current_page
              next_page
              prev_page
              total_pages
              total_records
            }
            posts {
              id
              title
              excerpt
              url
              color
              contrast_color
              published_at
              image(type: thumb800) {
                url
              }
              icon {
                binary
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
      params = {:blog => blog, :page => page, :per_page => options[:per_page] || 12, :month => options[:month], :year => options[:year]}
      result = Client.query(PostsQuery, :variables => params.compact)
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

    def current_page
      @page_info.current_page
    end

    def next_page
      @page_info.next_page
    end

    def prev_page
      @page_info.prev_page
    end

    def total_pages
      @page_info.total_pages
    end

    def total_posts
      @page_info.total_records
    end

  end
end
