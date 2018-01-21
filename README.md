# Abe Client

This is a client library for talking with the aTech Blogging engine (Abe). It uses the new GraphQL endpoints.

## Setup

```ruby
AbeClient.api_token = 'the-token'
# or
ENV['ABE_GRAPHQL_API_TOKEN'] = 'the-token'
```

## Getting a blog homepage

```ruby
homepage = AbeClient::BlogHomepage.get('blog-permalink')

# Get the contents for the feature boxes
for position, post in homepage.features
  position # => The name of the boxe
  post # => A post object containing the information required to render the feature
end

# Get the list of latest posts
for post in homepage.latest.posts
  post.title
  post.url
  post.image&.url
  # etc. etc...
end

# Get a list of categories to display
for category in homepage.categories
  category.name
  category.permalink
end
```

If no blog is found with the given permalink, `nil` will be returned from the `get` method.

## Getting a blog post

```ruby
if post = AbeClient::Blog.get('blog-permalink', 'post-permalink', 'browser-id')
  post.title
  post.html
  post.image&.url
  post.reactions
  post.reactions_for_browser
  # etc. etc... (refer to post GraphQL spec for details)
else
  puts "no post found"
end
```

The `browser-id` should be a random unique global string which is assigned to the
browser of the person browsing. It should go into their cookies and simply remembers
which reactions they selected so they can see them next time they occur.

## Getting a list of all posts

```ruby
posts = AbeClient::Posts.get('blog-permalink', 1, {})
puts "Showing #{posts.size} of #{posts.total_posts}"
for post in posts
  post.title
  post.excerpt
  # etc. etc...
end
```

Various options can be passed into this method to adjust the results that are returned.

* `:per_page` - the number of posts per page (defaults to 12)

## Toggling a reaction to a post

```ruby
# Don't forget to set a browser ID first...
if result = AbeClient::Post.toggle_reaction(post_id, reaction, request.cookies[:abe_browser_id], request.ip, request.user_agent)
  result.reactions               # => The latest reactions for the post
  result.reactions_for_browser   # => The list of reactions this browser has made
else
  puts "Could not react"
end
```

The valid `reaction` values are: `penguin`, `sad`, `heart`, `thumbsup`, `laughing`.

## Errors

If there are any communication errors when communicating with the GraphQL endpoint,
a `AbeClient::Error` will be raised. This should be caught so the site consuming the
API doesn't end up with a nasty 500 error.
