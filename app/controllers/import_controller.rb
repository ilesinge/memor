class ImportController < ApplicationController
  
  require 'nokogiri'
  
  # GET /import
  def index
    @file = ''
  end
  
  # POST /import
  def start
    if params[:file].nil?
      flash[:error] = 'The import file was missing!'
      return redirect_to(import_path)
    end
    success_count = 0
    error_count = 0
    doc = Nokogiri::HTML.parse(params[:file])
    doc.css('a').each do |link|
      post = Post.new
      post.title = link.content
      post.url = link['href']
      post.tag_list = link['tags']
      post.description = link['description']
      post.user = current_user
      post.created_at = Time.at(link['add_date'].to_i)
      post.save
      #link['hash']
      if post.invalid?
        error_count += 1
      else
        success_count += 1
      end
    end
    if success_count > 0
      flash[:notice] = success_count.to_s + ' posts were successfully imported :)'
    end
    if error_count > 0
      flash[:warning] = error_count.to_s + ' posts could not be imported <em>(probably because of duplicates or missing fields)</em>'
    end
    redirect_to import_path
  end
  
end