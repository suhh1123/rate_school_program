class UserMailer < ApplicationMailer
  default from: 'shhsuhaohua520@gmail.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to Rate-School-Program')
  end
end
