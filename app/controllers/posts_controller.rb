class PostsController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /
  def index
    post_model = Post
    if (params['user_id'])
      @user = User.find_by_username!(params['user_id'])
      post_model = post_model.where(user: @user)
    end
    @posts = post_model.all
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
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:url, :title, :description)
    end
end
