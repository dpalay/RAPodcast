require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :posts
  has_many :links
  
  
    #temporary attributes
  attr_accessor :remember_me, :current_password
  
  
  #Max & Min constants
  LOGIN_MIN_LENGTH = 4
  LOGIN_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 7
  PASSWORD_MAX_LENGTH = 20
  EMAIL_MIN_LENGTH = 6
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20
  LOGIN_RANGE = LOGIN_MIN_LENGTH..LOGIN_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
  EMAIL_RANGE = EMAIL_MIN_LENGTH..EMAIL_MAX_LENGTH
  SCREEN_NAME_RANGE =   SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH


  validates_length_of       :password, :within => PASSWORD_RANGE
  validates_length_of       :login,    :within => LOGIN_RANGE
  validates_length_of       :screen_name, :within =>   SCREEN_NAME_RANGE
  validates_length_of       :email,    :within => EMAIL_RANGE
  validates_uniqueness_of   :login, :email, :screen_name, :case_sensitive => false
  validates_format_of       :login,
                            :with => /^[A-Z0-9_]*$/i,
                            :message => "Must contain only letters," +
                                        " numbers, and underscores"
  validates_format_of       :email,
                            :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                            :message => "Must be a valid email address"
  validates_confirmation_of :password



  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :screen_name, :email, :password, 
                  :remember_me, :password_confirmation, :current_password

  #log a user in
  def login!(session)
    session[:user_id] = self.id
  end

  #log a user out
  def self.logout!(session, cookies)
    session[:user_id] = nil
    cookies.delete(:authorization_token)
  end
  
  #clear the password (used to suppress its display in a form)
  def clear_password!
    self.password = nil
    self.password_confirmation = nil
  end
  
  #remember a user
  def remember!(cookies)
    cookies[:remember_me] = { :value =>"1", 
                              :expires => 26.weeks.from_now }
    self.authorization_token = unique_identifier
    save!
    cookies[:authorization_token] = { :value => authorization_token,
                                      :expires => 1.week.from_now }
  end

  #forget a user
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end
  
  def remember_me?
    remember_me == "1"
  end
  
  #Checks to see if the password from params is correct
  def correct_password?(params)
    current_password = params[:user][:current_password]
    password == current_password
  end
  
  #Genereates messages for password erros
  def password_errors(params)
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    valid?
    #The current password is incorrect, so add an error message.
    erros.add(:current_password, "does not match")
  end
  
  private
  
  #Generate a unique identifier for the user
  def unique_identifier
    Digest::SHA1.hexdigest( "#{login}:#{screen_name}:#{password}" )
  end
    

end
