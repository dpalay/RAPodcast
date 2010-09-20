class PostController < ApplicationController
 before_filter :protect_admin
 before_filter :dnsbl_check
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @posts = Post.find(:all)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    if @postset == nil
      @postset = get_newest_postset
    end
    @post = @postset.posts.new
  end

  def create
    @postset = get_newest_postset
    @post = @postset.posts.new(params[:post])
    @post.postset_id = @postset.id
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to :controller => 'postset', :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      redirect_to :controller => 'postset', :action => 'view', :id => @post.postset
    else
      render :action => 'edit'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
    def authorized?
      logged_in? and admin?
    end
  
end
