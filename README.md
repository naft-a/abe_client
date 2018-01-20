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
require 'abe_client/blog_homepage'
homepage = AbeClient::BlogHomepage.get('blog-permalink')

# Get the contents for the feature boxes
for position, post in homepage.features
  position # => The name of the boxe
  post # => A post object containing the information required to render the feature
end

# Get the list of latest posts
for post in homepage.latest
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

## Errors

If there are any communication errors when communicating with the GraphQL endpoint,
a `AbeClient::Error` will be raised. This should be caught so the site consuming the
API doesn't end up with a nasty 500 error.
