class UsersController < ApplicationController
  before_action :check_access
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  #def show
  #end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, notice: I18n.t('user_created')
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /users/1
  def update
    if user_params[:password] == ""
      updated = @user.update_without_password(user_params)
    else
      updated = @user.update(user_params)
    end
    if updated
      if @user.id == current_user.id
        sign_in @user, :bypass => true
      end
      redirect_to users_path, notice: I18n.t('user_updated')
    else
      render action: 'edit'
    end
  end

  # DELETE /user/1
  def destroy
    if @user == current_user
      flash[:error] = I18n.t('cannot_delete_yourself')
      return redirect_to users_path
    else
      @user.destroy
      redirect_to users_path, notice: I18n.t('user_deleted')
    end
  end

  private
    # Verify if the current user can manage users
    def check_access
      if current_user.nil? or !current_user.is_admin?
        flash[:error] = t('no_access')
        redirect_to :root
        return false
      end
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.where(:username => params[:id]).first!
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :password)
    end
end
