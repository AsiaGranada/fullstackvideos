class RegistrationsController < Devise::RegistrationsController
  protect_from_forgery :except => :create
  after_action :process_order, :only => :create

  def new
    build_resource({})
    yield resource if block_given?
    self.resource.coupon = Coupon.new
    respond_with self.resource
  end

  def expire
    if current_user.subscriber?
      CancelSubscriptionJob.perform_later(current_user)
      current_user.cancelled = true
      current_user.save!
      redirect_to root_path, :alert => "Subscription cancelled. No further charges.
        Access continues until the end of the subscription period."
    else
      redirect_to root_path, :alert => "Subscription not found."
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation,
      :stripe_token, {coupon_attributes: [:code]})
  end

  def process_order
    return if resource.admin?
    if resource.persisted?
      PaymentJob.perform_later(resource) unless resource.coupon.price == 0
      MailingListSignupJob.perform_later(resource)
    end
  end

end
