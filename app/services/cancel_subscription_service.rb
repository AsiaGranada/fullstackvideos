class CancelSubscriptionService

  def perform(user)
    customer = Stripe::Customer.retrieve(user.stripe_id)
    customer.subscriptions.each do |s|
      subscription = customer.subscriptions.retrieve(s.id).delete(at_period_end: true)
      Rails.logger.info("cancelling #{user.email} subscription at period end")
    end
  end

end
