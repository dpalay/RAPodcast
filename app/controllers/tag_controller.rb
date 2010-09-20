class TagController < ApplicationController
  before_filter :protect_admin, :except => [:search, :tag, :tagcloud]
         
  def tag
  	@tag_id = params[:id].to_s
  	if params[:id2]
  		@tag_id = @tag_id + "." + params[:id2].to_s
  	end
  	@title = "Listing all episodes with #{@tag_id}"
    @postsets = Postset.find_tagged_with(@tag_id, :order => "id")
  end
  
  def tagcloud
  	@title = "The Tag Cloud - Click on a tag to find episodes with it listed!"
    @tags = Postset.tag_counts
  end
  
  def search
    @postsets = Postset.find_tagged_with(params[:q], :order => "id")
    render  :action => 'tag'
  end

end
