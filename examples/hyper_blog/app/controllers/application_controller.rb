class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionHelper
  before_filter :set_todays_posts
  
  def set_todays_posts
    t1 = Time.now.advance(days: -3).beginning_of_day
    @todays_posts = [] #Post.where("created_at" => [t1, Time.now.to_i])
    @tags = Tag.where(order: :name, sort: :asc)
  end
end
