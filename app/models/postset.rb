class Postset < ActiveRecord::Base
  acts_as_taggable
  has_many :posts
  has_many :links
  
  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :title
  validates_uniqueness_of :podcast_link, :scope => :podcast_link
  validates_uniqueness_of :created_at

end
