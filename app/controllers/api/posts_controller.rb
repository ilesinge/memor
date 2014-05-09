class Api::PostsController < Api::ApiController
  
  def all
    @posts = current_user.posts.includes(:tags, :user).order(created_at: :desc)
    if params[:tag] and !params[:tag].empty?
      @tag = params[:tag]
      @posts = @posts.tagged_with(@tag)
    end
  end
  
  def add
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
        if params[:tags]
          post.tag_list = params[:tags].split(' ')
        else
          post.tag_list = []
        end
        post.user = current_user
        post.save!
        @code = 'done'
        render 'result'
      end
    end
  end
  
  def update
	@post = current_user.posts.order(created_at: :desc).first
	if @post.nil?
		@post = Post.new
		@post.updated_at = DateTime.parse('1970-01-01 00:00:00 UTC')
	end
  end
  
  def delete
	post = current_user.posts.find_by(url: params[:url])
	if post
		post.destroy!
		@code = 'done'
		render 'result'
	else
		request.format = :html
		render :text => "item not found", :status => 404, :content_type => 'text/plain'
	end
  end
  
end
