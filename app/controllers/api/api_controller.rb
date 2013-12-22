class Api::ApiController < ApplicationController
  
  before_filter :check_auth, :set_xml_format
  
  private
  
  def check_auth
    authenticate_or_request_with_http_basic do |username,password|
      resource = User.find_by_username(username)
      if resource and resource.valid_password?(password)
        sign_in :user, resource
      end
    end
  end
  
  def set_xml_format
    request.format = :xml
  end
  
end