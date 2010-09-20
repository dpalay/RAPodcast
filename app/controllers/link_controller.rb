class LinkController < ApplicationController
  include ApplicationHelper
  include LinkHelper
  
layout "main"
before_filter :protect
before_filter :protect_admin, :only => [:show, :list, :update, :edit]
before_filter :dnsbl_check

 # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def new
    @link = Link.new
  end
  
  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])
    if @link.update_attributes(params[:link])
      flash[:notice] = 'Post was successfully updated.'
      redirect_to :controller => 'link', :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def show
    @link = Link.find(params[:id])
  end


  def create
    @link = Link.new(params[:link])
    if logged_in?
      @link.user = current_user
    end
    @link.postset_id = -1
    if @link.save
      respond_to do |format|
    	format.html {redirect_to :controller => 'postset', :action => 'index'}
    	format.js {render :update do |page|
        	page.insert_html :bottom, :linkul, :partial => 'postset/linklist', :object => @link
			page[:link_submit_form].reset
			page.replace_html  :link_flash, 'Link saved!'
			page.replace_html :link_error, ""
        end}
	  end
    else
    	respond_to do |format|
        format.html {redirect_to :controller => 'postset', :action => 'index'}
        format.js  {render :update do |page|
        	page.replace_html :link_flash, ""
        	page.replace_html  :link_error, "Errors: <br>
        									 Title - #{@link.errors.on(:title) do |e| $stdout.puts e end} <br>
        									 URL - #{@link.errors.on(:url) do |e| $stdout.puts e end}"
        	flash.discard
        end}
      end
	end
  end

  def delete
    @link = Link.find_by_id(params[:id])
  end
  
  def list
    @link = Link.find(:all)
  end
  
  def destroy
    Link.find(params[:id]).destroy
    redirect_to :controller => 'postset', :action => 'index'
  end
  
  
end
