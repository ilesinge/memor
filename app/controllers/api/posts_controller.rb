class Api::PostsController < Api::ApiController
  
  def all
    @posts = current_user.posts
    if params[:tag]
      @tag = params[:tag]
      @posts = @posts.tagged_with(@tag)
    end
    respond_to do |format|
      format.xml
    end
  end
  
  def add
    request.format = :html
    render status: :bad_request, :text => 'URL missing'
  end
  
end
