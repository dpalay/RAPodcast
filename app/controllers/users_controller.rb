class UsersController < ApplicationController
  include ApplicationHelper
   before_filter :dnsbl_check

  def index
    @title = "User Control"
    @user = current_user
  end

  def register
    @title = "Register"
    if param_posted?(:user)
      @user = User.new(params[:user])
      if @user.save
        ContactMail.deliver_signup_confirmation_request(@user, confirmation_hash(@user.login))
        flash[:notice] = "User #{@user.screen_name} created! " + 
                         "We have sent an email to the address provided " +
                         "to confirm your registration. Please click on the link " +
                         "provided in the email to finish!  If you don't see the email, " + 
                         "please check your spam folder."
       redirect_to :controller => :postset, :action => :index
     else
       @user.clear_password!
     end
   end
 end
 
  def request_password_email
    @title = "Request A Password Reminder"
    if param_posted?(:user)
      if (@user = User.find_by_email(params[:user][:email]))
        ContactMail.deliver_password_reminder(@user)
        flash[:notice] = "Password reminder sent to #{@user.email}"
        redirect_to :action => :login
      else
        flash[:notice] = "That email is not associated with a user account"
      end
    end
  end

  def login
    @title = "Login"
        #TODO Check here for login spamming.  5 attempts per hour since last login
        session[:login_tries]||=0
    if request.get?
      @user = User.new(:remember_me => remember_me_string)
    elsif param_posted?(:user)
      @user = User.new(params[:user])
      user = User.find_by_login_and_password(@user.login, @user.password)
      if (user)
        if user.is_active
          user.login!(session)
          @user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
          flash[:notice] = "Welcome #{user.screen_name}, to RAPodcast!"
          session[:login_tries] = 0;
          redirect_to_forwarding_url
        else
          @user.clear_password!
          session[:login_tries] = session[:login_tries] + 1
          flash[:notice] = "This username has not been activated.  Please check the email associated with your login for a message with the subject 'Confirm User Registration' from no_reply@rapodcast.net for the link to activate."
        end
      else
        #Remove Password from view
        @user.clear_password!
        session[:login_tries] = session[:login_tries] + 1
        flash[:notice] = "Invalid login/password combination"
      end
    end
  end
  
  def logout
    if logged_in?
      flash[:notice] = "#{User.find(session[:user_id]).screen_name} logged out succesfully."
      User.logout!(session, cookies)
    else
      flash[:notice] = "You weren't even logged in!"
    end
    redirect_to :controller => :postset, :action => :index
  end
  
  def confirm_email
    @title = "User Account Confirmation"
    @users = User.find :all

    for user in @users
      # if the passed hash matches up with a User, confirm him, log him in, set proper flash[:notice], and stop looking
      if confirmation_hash(user.login) == params[:hash] and !user.is_active
        #user.update_attributes!(:is_active => true)
        user.is_active = true;
        user.save!
        user.login!(session)
        flash[:notice] = "Thank you for validating your email, you have been logged in. "
        ContactMail.deliver_signup_notification(user)
        break
      end
    end
    redirect_to :controller => :postset, :action => :index
  end
  
  
  def edit_site_info
    #TODO: Confirm new email!
    #TODO: Fix this page!
    @title = "Edit User Information"
    @user = current_user
    if param_posted?(:user)
      attribute = params[:attribute]
      case attribute
      when "email"
          try_to_update @user, attribute
      when "password"
        if @user.correct_password?(params)
          try_to_update @user, attribute
        else
          @user.password_errors(params)
        end
      end
    end
    @user.clear_password!
  end
  
  private
  
  #Try to update user, redirecting if possible
  def try_to_update(user, attribute)
    if (user.update_attributes(params[:user]))
      flash[:notice] = "user #{attribute} updated!"
      redirect_to :action => "index", :id => user.id
    end
  end
  
  #Return true if a parameter corresponding to the given symbol was posted
  def param_posted?(symbol)
    request.post? and params[symbol]
  end
  
  #Redirect to the previously requested URL (if present)
  def redirect_to_forwarding_url
    if (redirect_url = session[:protected_page])
          session[:protected_page] = nil
          redirect_to redirect_url
    else
        redirect_to :controller => :postset, :action=> "index"
    end
  end
  
  #Return a string with the status of the remember me checkbox.
  def remember_me_string
    cookies[:remember_me] || "0"
  end
  
  
end
