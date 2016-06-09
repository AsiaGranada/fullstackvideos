class CancelSubscriptionJob < ActiveJob::Base

  def perform(user)
    CancelSubscriptionService.new.perform(user)
  end

end
