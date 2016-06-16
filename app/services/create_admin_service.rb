class CreateAdminService
  def call
    user = User.where(email: Rails.application.secrets.admin_email).first_or_initialize do |u|
      u.password = Rails.application.secrets.admin_password
      u.password_confirmation = Rails.application.secrets.admin_password
      u.role = :admin
    end
    user.save!(:validate => false) if user.new_record?
    user
  end
end
