class Api::PostsController < Api::ApiController
  
  def all
    @posts = current_user.posts.includes(:tags, :user).order(created_at: :desc)
    if params[:tag] and !params[:tag].empty?
      @tag = params[:tag]
      @posts = @posts.tagged_with(@tag)
    end
  end
  
  def add
    if request.post?
      params = post_params
    end
    replace = (params[:replace] == 'yes')
    proceed = false
    
    if !params[:url] or params[:url].empty?
      @code = 'URL missing'
      render 'result', status: :bad_request
    elsif !params[:description] or params[:description].empty?
      @code = 'Description missing'
      render 'result', status: :bad_request
    else
      post = Post.where('url' => params[:url]).first
      if !post.nil?
        if !replace
          @code = 'bookmark does already exist'
          render 'result', status: :conflict
        else
          proceed = true
        end
      else
        post = Post.new
        proceed = true
      end
      if proceed
        post.url = params[:url]
        post.title = params[:description]
        post.description = params[:extended]
        post.user = current_user
        post.tags = params[:tags].split(' ')
        post.save!
        @code = 'done'
        render 'result'
      end
    end
  end
  
end
