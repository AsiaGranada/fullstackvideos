class MailingListSignupJob < ActiveJob::Base
  # include Rollbar::ActiveJob

  def perform(user)
    mailchimp = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    subscribe_with_affiliation(mailchimp, user)
  end

  def subscribe_with_affiliation(mailchimp, user)
    list_id = user.coupon.mailing_list_id
    category_title = 'AFFILIATION'
    if user.coupon.list_group.nil?
      interest_name = 'SUBSCRIBER'
    else
      interest_name = user.coupon.list_group.upcase
    end
    interest_id = interest_id_by_name(mailchimp, list_id, category_title, interest_name)
    begin
      result = mailchimp.lists(list_id).members.create(
        body: {
          email_address: user.email,
          status: 'subscribed',
          merge_fields: {NAME: user.name},
          interests: Hash[interest_id, true]
      })
    rescue Gibbon::MailChimpError => exception
      Rails.logger.error("add to MailChimp list failed for #{user.email}")
      Rails.logger.error("list_id: #{list_id}, interest_name: #{interest_name}, interest_id: #{interest_id}")
      Rails.logger.error("exception.message #{exception.message}")
      Rails.logger.error("exception.detail #{exception.detail}")
      Rails.logger.error("exception.body #{exception.body}")
      Rollbar.error(exception.detail, :user_info => user.email) unless exception.body['status'] == 400
    end
    Rails.logger.info("Subscribed #{user.email} to MailChimp list with group #{user.coupon.list_group.upcase}") if result
  end

  def subscribe_without_affiliation(mailchimp, user)
    begin
      result = mailchimp.lists(user.coupon.mailing_list_id).members.create(body:{
        email_address: user.email,
        status: 'subscribed',
        merge_fields: {NAME: user.name}
      })
    rescue Gibbon::MailChimpError => exception
      Rails.logger.error("add to MailChimp list failed for #{user.email}")
      Rails.logger.error("exception.message #{exception.message}")
      Rails.logger.error("exception.detail #{exception.detail}")
      Rails.logger.error("exception.body #{exception.body}")
      Rollbar.error(exception.detail, :user_info => user.email) unless exception.body['status'] == 400
    end
    Rails.logger.info("Subscribed #{user.email} to MailChimp (without AFFILIATION)") if result
  end

  def interest_id_by_name(mailchimp, list_id, category_title, interest_name)
      return nil if (list_id.nil? || category_title.nil? || interest_name.nil?)
      category_id = category_id_by_title(mailchimp, list_id, category_title)
      interests = mailchimp.lists(list_id).interest_categories(category_id).interests.retrieve(params: {"count": "100"})
      interests['interests'].each do |interest|
        if interest['name'] == interest_name
          return interest['id']
        end
      end
      return nil
  end

  def category_id_by_title(mailchimp, list_id, category_title)
      return nil if (list_id.nil? || category_title.nil?)
      json_hash = mailchimp.lists(list_id).interest_categories.retrieve(params: {"count": "100"})
      json_hash['categories'].each do |category|
        if category['title'] == category_title
          return category['id']
        end
      end
      return nil
  end

end
