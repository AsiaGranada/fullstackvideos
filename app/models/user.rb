class User < ActiveRecord::Base
  enum role: [:admin, :user, :subscriber, :expired]
  after_initialize :set_default_role, :if => :new_record?
  after_validation :set_coupon

  belongs_to :coupon
  accepts_nested_attributes_for :coupon
  validates_associated :coupon

  before_destroy :cancel_subscription

  def set_default_role
    self.role ||= :user
  end

  def set_coupon
    self.coupon.code = 'FREE' if self.admin?
    return false if errors.any?
    return false if self.coupon.nil?
    coupon = Coupon.find_by code: self.coupon.code
    self.coupon = coupon
  end

  def cancel_subscription
    CancelSubscriptionJob.perform_later(self) if self.subscriber?
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
