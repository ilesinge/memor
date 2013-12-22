class Api::PostController < Api::ApiController
  
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
  
end
