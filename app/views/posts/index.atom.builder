  atom_feed do |feed|
    feed.title("Memor")
    feed.updated((@posts.last.created_at)) unless @posts.last.nil?

    @posts.each do |post|
      feed.entry(post, url: post.url) do |entry|
        entry.title(post.title)
        entry.content(post.description)

        entry.author do |author|
          author.name(post.user.username)
        end
      end
    end
  end
