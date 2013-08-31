class PostsController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]

  # GET /
  def index
    post_model = Post.order(:id).reverse_order.page params[:page]
    if (params['user_id'])
      post_model = post_model.joins(:user).where('users.username' => params['user_id'])
    end
    if (params['tag_id'])
      post_model = post_model.tagged_with(params['tag_id'])
    end
    @posts = post_model
    
    respond_to do |format|
      format.html
      format.atom { render :layout => false } #index.atom.builder
    end
  end

  # GET /1
  def show
  end

  # GET /new
  def new
    @post = Post.new
  end

  # GET /1/edit
  def edit
  end

  # POST /
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post "'+@post.title+'" was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:url, :title, :description, :tag_list)
    end
    
    # Verify if the current user can modify/delete this post
    def check_access
      if @post.user != current_user
        flash[:error] = "You cannot modify this post"
        redirect_to :root
      end
    end
end
