class Api::PostsController < Api::ApiController
  
  def all
    @posts = current_user.posts.includes(:tags, :user).order(created_at: :desc)
    if params[:tag] and !params[:tag].empty?
      @tag = params[:tag]
      @posts = @posts.tagged_with(@tag)
    end
  end
  
  def add
    request.format = :html
    render status: :bad_request, :text => 'URL missing'
  end
  
end
