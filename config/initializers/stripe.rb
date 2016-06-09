# set the Stripe keys in the file config/secrets.yml
Stripe.api_key = Rails.application.secrets.stripe_api_key

StripeEvent.configure do |events|
  events.subscribe 'customer.subscription.deleted' do |event|
    if @user = User.find_by_stripe_id(event.data.object.customer)
      Rails.logger.info("Stripe webhook rec'd: customer.subscription.deleted for #{@user.email}")
      @user.expired!
      @user.save!
    end
  end
end
