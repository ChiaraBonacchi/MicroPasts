class UserObserver < ActiveRecord::Observer
  observe :user

  def before_validation(user)
    user.password = SecureRandom.hex(4) unless user.password || user.persisted?
  end

  def after_create(user)
    return if user.email =~ /change-your-email\+[0-9]+@neighbor\.ly/
    WelcomeWorker.perform_async(user.id)
  end
end
