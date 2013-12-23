xml.instruct!
xml.posts('update' => DateTime.now.xmlschema, 'user' => current_user.username, 'tag' => @tag) {
  @posts.each do |post|
    xml.post('href' => post.url,
      'description' => post.title,
      'extended' => post.description,
      'hash' => Digest::MD5.hexdigest(post.url),
      'tag' => post.tags.join(' '),
      'time' => post.created_at.xmlschema)
  end
}