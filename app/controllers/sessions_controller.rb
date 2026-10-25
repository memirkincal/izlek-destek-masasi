class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: I18n.t("auth.too_many_signins") }

  def new
    @portal = params[:portal].presence_in(%w[requester staff])
  end

  def create
    portal = params[:portal].presence_in(%w[requester staff])
    user = User.authenticate_by(params.permit(:email_address, :password))

    if user && (portal.nil? || (portal == "requester" ? user.requester? : user.support_staff?))
      start_new_session_for user
      redirect_to after_authentication_url, notice: t("auth.signed_in")
    else
      redirect_to new_session_path(portal: portal), alert: t("auth.invalid_credentials")
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other, notice: t("auth.signed_out")
  end
end
