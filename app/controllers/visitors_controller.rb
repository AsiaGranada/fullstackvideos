class VisitorsController < ApplicationController

  def index
    @resource = User.new
    @resource.coupon = Coupon.new
    @thisweekvideo = Video.all.order('created_at DESC').first
    @freevideos = Video.free.order('created_at DESC')
    @advancedvideos = Video.advanced.order('created_at DESC')
    @beginnervideos = Video.beginner.order('created_at DESC')
  end

end
