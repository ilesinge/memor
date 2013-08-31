class TagsController < ApplicationController
  # GET /tags
  def index
    available_tags = []
    tags = ActsAsTaggableOn::Tag
    if params.key? 'term'
      term = params['term'].gsub('%', '\\\\\%').gsub('_', '\\\\\_')
      tags = tags.where('name like ?', "#{term}%")
    else
      tags = tags.all
    end
    tags.each do |tag|
      available_tags << {
        :id => tag.id,
        :label => tag.name,
        :value => tag.name
      }
    end
    render :json => available_tags
  end
end
