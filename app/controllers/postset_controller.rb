class PostsetController < ApplicationController
  before_filter :protect_admin, :except => [:view, :index, :tag, :tagcloud, :rapodcast]
  before_filter :dnsbl_check
  

  def index
    @postset = get_newest_postset
    @title = @postset.title
    @next = @postset
    @first = Postset.find(:first)
    if @postset == @first
      @prev = @postset
    else
      @prev = Postset.find(:all, :conditions => [ "id < ?", @postset.id]).last
    end
    render :action => 'view'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :publish ],
         :redirect_to => { :action => :view, :id => Postset.find(:first).id }
         
  
  def list
    @postset = Postset.find(:all)
  end

  def show
    @postset = Postset.find(params[:id])
  end
  
  def publish
    @postset = Postset.find(params[:id])
    @postset.update_attribute(:published, 'true')
    redirect_to :action => 'view', :id => @postset
    
    #TODO Add notification that next episode is out
  end

  def new
    @postset = Postset.new
  end

  def create
    @postset = Postset.new(params[:postset])
    if @postset.save
      for link in Link.find(:all, :conditions => {:postset_id => -1})
        link.update_attribute(:postset_id, @postset.id)
      end

      flash[:notice] = 'Postset was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @postset = Postset.find(params[:id])
  end

  def update
    @postset = Postset.find(params[:id])
    if @postset.update_attributes(params[:postset])
      flash[:notice] = 'Postset was successfully updated.'
      redirect_to :action => 'view', :id => @postset
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @postset = Postset.find(params[:id])
    Post.delete_all "postset_id = #{@postset.id}"
    @postset.destroy
    
    redirect_to :action => 'list'
  end
  
  def view
    @postset = Postset.find(params[:id])    
    @first = Postset.find(:first)
    if @postset == Postset.find(:first)
      @prev = @postset
    else
      @prev = Postset.find(:all, :conditions => [ "id < ?", @postset.id]).last
    end
  
    if (Postset.find(@postset.id) == Postset.find(:all).last)
      @next = @postset
    else
      @next = Postset.find(:all, :conditions => [ "id > ?", @postset.id]).first
    end 
  end
  
  def rapodcast
  	@postsets = Postset.find(:all, :conditions => {:published => true})
  	@postset_and_post_array = Array.new()
  	for postset in @postsets
  		@postset_and_post_array[@postset_and_post_array.size] = postset
  		for post in postset.posts
  			@postset_and_post_array[@postset_and_post_array.size] = post
  		end
  	end	
  	@postset_and_post_array.reverse!
  end

  def move_links
	links = Postset.find(:all).last.links
	for link in links
	  link.postset_id = -1
	  link.save!
	end
	redirect_to :action => 'index'
  end
  	
end
