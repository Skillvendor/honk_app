class UserMailer < ApplicationMailer
	 default from: "tarna.lucian@gmail.com"

  def confirmation_email(user, url)
    @user = user
    @url  = url
    mail(to: @user.email, subject: 'Inregistrare HonkA')
  end
end
