class SubscriptionsController < ApplicationController

  def expire
    Rails.logger.info "\033[1;34;40m[DEBUG]\033[0m"
    Rails.logger.info("try to expire #{current_user.email}")
    if current_user.subscriber?
      CancelSubscriptionJob.perform_later(current_user)
      current_user.cancelled = true
      current_user.save!
      redirect_to edit_user_registration_path, :alert => "Subscription cancelled."
    else
      redirect_to edit_user_registration_path, :alert => "Subscription not found."
    end
  end

end
