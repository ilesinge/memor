class ExportController < ApplicationController
  
  before_action :check_access
  
  # POST /export
  def index
    @posts = current_user.posts.order(:created_at).all
    @now = Time.now.to_i
    file = render_to_string "export/index", :layout => false
    send_data file, :type => 'text/html', :filename => 'Bookmarks.html'
  end
  
  private
  
  def check_access
    if current_user.nil?
      flash[:error] = t('no_access')
      redirect_to :root
      return false
    end
  end
  
end
