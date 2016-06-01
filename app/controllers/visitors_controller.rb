class VisitorsController < ApplicationController

  def index
    @resource = User.new
    @resource.coupon = Coupon.new
    @freevideos = Video.all
    @paidvideos = Video.all
  end

end
