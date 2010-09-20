class Post < ActiveRecord::Base
  belongs_to :postset
  belongs_to :user
  
end
