class ExpireSubscriptionJob < ActiveJob::Base
  # include Rollbar::ActiveJob

  def perform(user)
    mailchimp = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    remove_from_canceling_list(mailchimp, user)
    add_to_expired_list(mailchimp, user)
  end

  # List ID: '1f73822e27', # List: "Fullstack Videos Canceling"
  def remove_from_canceling_list(mailchimp, user)
    return if not Rails.env.production?
    uid = Digest::MD5.hexdigest(user.email.downcase)
    result = mailchimp.lists('1f73822e27').members(uid).update(body: { status: "unsubscribed" })
    Rails.logger.info("Unsubscribed #{user.email} from MailChimp Fullstack Videos Canceling List") if result
  rescue Gibbon::MailChimpError => e
    Rails.logger.info("MailChimp Fullstack Videos Canceling List unsubscribe failed for #{user.email}: " + e.message)
  end

  # List ID: '067676fdcf', # List: "Fullstack Videos Expired
  def add_to_expired_list(mailchimp, user)
    begin
      result = mailchimp.lists('067676fdcf').members.create(body:{
        email_address: user.email,
        status: 'subscribed',
        merge_fields: {NAME: user.name}
      })
    rescue Gibbon::MailChimpError => exception
      Rails.logger.error("add to MailChimp Fullstack Videos Expired list failed for #{user.email}")
      Rails.logger.error("exception.message #{exception.message}")
      Rails.logger.error("exception.detail #{exception.detail}")
      Rails.logger.error("exception.body #{exception.body}")
      Rollbar.error(exception.detail, :user_info => user.email)
    end
    Rails.logger.info("Subscribed #{user.email} to MailChimp Fullstack Videos Expired list") if result
  end

end
