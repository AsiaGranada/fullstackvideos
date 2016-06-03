class VisitorsController < ApplicationController

  def index
    @resource = User.new
    @resource.coupon = Coupon.new
    @freevideos = Video.free
    @advancedvideos = Video.advanced
    @beginnervideos = Video.beginner
  end

end
