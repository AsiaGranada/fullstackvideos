class AddCouponRefToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :coupon, foreign_key: true
  end
end
