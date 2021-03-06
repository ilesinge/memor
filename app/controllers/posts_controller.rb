class PostsController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :check_access, only: [:edit, :update, :destroy]

  # GET /
  def index
    @filters, @posts = get_filters(params)
    @posts = @posts.includes(:tags, :user)
    @tags = @posts.tag_counts_on(:tags)
    
    respond_to do |format|
      format.html
      format.atom { render :layout => false } #index.atom.builder
    end
  end

  # GET /1
  def show
    @related = @post.find_related_on_tags[0..5]
  end

  # GET /new
  def new
    
    existing_post = Post.where('url' => params['url']).first
    if !existing_post.nil?
      return redirect_to(existing_post)
    end
    
    @post = Post.new
    if params['url']
      @post.url = params['url']
      @post.title = params['title']
      @post.description = params['description']
      
      @suggested_tags = suggested_tags @post
    end
  end

  # GET /1/edit
  def edit
  end

  # POST /
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to @post, notice: t('post_created')
    else
      check_existence post_params
      render action: 'new'
    end
  end

  # PATCH/PUT /1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: t('post_updated')
    else
      check_existence post_params
      render action: 'edit'
    end
  end

  # DELETE /1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: t('post_deleted', post: @post.title)
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
        flash[:error] = t('cannot_edit_post')
        redirect_to :root
        return false
      end
    end
    
    def suggested_tags(post)
      suggested_tags = []
      if !post.title.empty? or !post.description.empty?
        ActsAsTaggableOn::Tag.all.each do |tag|
          if post.title.downcase.include? tag.name or post.description.downcase.include? tag.name 
            suggested_tags.push(tag.name)
          end
        end
      end
      suggested_tags
    end
    
    def check_existence(post_params)
      existing_post = Post.where('url' => post_params['url']).first
      if !existing_post.nil? and existing_post.id != post_params['id']
        flash.now[:warning] = I18n.t('existing_post') + ' <a class="alert-link" href="' + url_for(existing_post) + '">' + h(existing_post.title) + '</a>'
      end
    end
    
    def get_filters(params)
      filters = {:tags => []}
      post_model = Post.order(:created_at).reverse_order.page params[:page]
      if (params['user_id'])
        post_model = post_model.joins(:user).where('users.username' => params['user_id'])
        filters[:user] = params['user_id'] 
      end
      if (params['tag_id'])
        tags = params['tag_id'].split(',')
        tags.each do |tag|
          post_model = post_model.tagged_with(tag)
          filters[:tags].append(tag) 
        end
      end
      if (params['q'])
        q = "%#{params['q']}%"
        post_model = post_model.where("title like ? or description like ?", q, q)
        filters[:q] = params['q'] 
      end
      return filters, post_model
    end
    
end
