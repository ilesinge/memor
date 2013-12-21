module PostsHelper
  include ActsAsTaggableOn::TagsHelper
  
  def filter_link_without(type, tag_name='')
    filters = @filters.deep_dup || {:tags => []}
    
    case type
    when :user
      filters.except!(:user)
    when :tag
      filters[:tags].delete(tag_name)
    when :q
      filters.except!(:q)
    end
    
    filter_link filters
  end
  
  def filter_link_with(type, name)
    filters = @filters.deep_dup || {:tags => []}
        
    case type
    when :user
      filters[:user] = name
    when :tag
      filters[:tags].append(name) unless filters[:tags].include? name
    when :q
      filters[:q] = name
    end
    
    filter_link filters
  end
  
  def filter_link(filters)
    user = filters[:user] 
    tags = filters[:tags].join(',')
    q = filters[:q]
    
    if user and tags.empty?
      path = user_posts_path user
    elsif !user and !tags.empty?
      path = tag_posts_path tags
    elsif user and !tags.empty?
      path = user_tag_posts_path user, tags
    else
      path = posts_path
    end
    if q
      path += '?q=' + u(q)
    end
    path
  end
  
end
