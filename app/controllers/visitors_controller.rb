class VisitorsController < ApplicationController

  def index
    @resource = User.new
    @resource.coupon = Coupon.new
    @freevideos = Video.free.order('created_at DESC')
    @advancedvideos = Video.advanced.order('created_at DESC')
    @beginnervideos = Video.beginner.order('created_at DESC')
  end

end
