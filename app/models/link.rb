class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :postset
  
  validates_presence_of :url, :title
  
  before_save :check_from_admin
  

  
  protected
  def check_from_admin
    unless self.user_id == nil
      self.from_admin = self.user.is_admin?
      true
    else
      self.from_admin = false
      true
    end
  end
end
