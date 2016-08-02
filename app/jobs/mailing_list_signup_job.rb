class MailingListSignupJob < ActiveJob::Base
  include Rollbar::ActiveJob

  def perform(user)
    mailchimp = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)
    subscribe_with_affiliation(mailchimp, user)
  end

  def subscribe_with_affiliation(mailchimp, user)
    if user.coupon.mailing_list_id.blank?
      list_id = '015b1c951c'
      Rails.logger.info("user.coupon.mailing_list_id is blank")
    else
      list_id = user.coupon.mailing_list_id
      Rails.logger.info("user.coupon.mailing_list_id is #{user.coupon.mailing_list_id}")
    end
    category_title = 'AFFILIATION'
    if user.coupon.list_group.blank?
      interest_name = 'SUBSCRIBER'
    else
      interest_name = user.coupon.list_group.upcase
    end
    interest_id = interest_id_by_name(mailchimp, list_id, category_title, interest_name)
    begin
      unless user.name.blank?
        result = mailchimp.lists(list_id).members.create(
          body: {
            email_address: user.email,
            status: 'subscribed',
            merge_fields: {NAME: user.name},
            interests: Hash[interest_id, true]
        })
      else
        result = mailchimp.lists(list_id).members.create(
          body: {
            email_address: user.email,
            status: 'subscribed',
            interests: Hash[interest_id, true]
        })
      end
    rescue Gibbon::MailChimpError => exception
      Rails.logger.error("add to MailChimp list failed for #{user.email}")
      Rails.logger.error("list_id: #{list_id}, interest_name: #{interest_name}, interest_id: #{interest_id}")
      Rails.logger.error("exception.message #{exception.message}")
      Rails.logger.error("exception.detail #{exception.detail}")
      Rails.logger.error("exception.body #{exception.body}")
      Rollbar.error(exception.detail, :user_info => user.email) unless exception.body['status'] == 400
    end
    Rails.logger.info("Subscribed #{user.email} to MailChimp list") if result
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
      return nil if (list_id.blank? || category_title.blank? || interest_name.blank?)
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
      return nil if (list_id.blank? || category_title.blank?)
      Rails.logger.info("category_id_by_title: list_id is #{list_id}")
      json_hash = mailchimp.lists(list_id).interest_categories.retrieve(params: {"count": "100"})
      json_hash['categories'].each do |category|
        if category['title'] == category_title
          return category['id']
        end
      end
      return nil
  end

end
